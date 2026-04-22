import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/settings_provider.dart';
import '../utils/formatters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart' as geo;

class MapMonitoringScreen extends StatefulWidget {
  const MapMonitoringScreen({super.key});

  @override
  State<MapMonitoringScreen> createState() => _MapMonitoringScreenState();
}

class _MapMonitoringScreenState extends State<MapMonitoringScreen> {
  final ApiService _api = ApiService();
  final MapController _mapController = MapController();
  List<dynamic> _loginLogs = [];
  List<dynamic> _colombiaCities = [];
  List<String> _departments = [];
  List<String> _cities = [];
  List<dynamic> _sucursales = [];
  bool _isShowingSucursales = false;
  
  String? _selectedDept;
  String? _selectedCity;
  
  bool _isLoading = true;
  dynamic _selectedLog;
  bool _showSessions = false; // collapsed by default on mobile
  LatLng? _pickedLocation; // New picked point

  @override
  void initState() {
    super.initState();
    _initCache();
    _fetchLogs();
    _fetchSucursales();
    _loadLocationData();
  }

  Future<void> _fetchSucursales() async {
    try {
      final data = await _api.getSucursales();
      setState(() => _sucursales = data);
    } catch (e) {
      debugPrint('Error fetching sucursales: $e');
    }
  }

  Future<void> _initCache() async {
    // Cache disabled for web compatibility simplicity
  }

  Future<void> _loadLocationData() async {
    try {
      final jsonString = await DefaultAssetBundle.of(context).loadString('assets/maps/colombia_cities.json');
      final List<dynamic> data = json.decode(jsonString);
      setState(() {
        _colombiaCities = data;
        _departments = data.map((e) => e['dpto'].toString()).toSet().toList()..sort();
      });
    } catch (e) {
      debugPrint('Error loading location data: $e');
    }
  }

  void _onDeptChanged(String? dept) {
    setState(() {
      _selectedDept = dept;
      _selectedCity = null;
      if (dept != null) {
        _cities = _colombiaCities
            .where((e) => e['dpto'] == dept)
            .map((e) => e['nom_mpio'].toString())
            .toList()..sort();
            
        final matches = _colombiaCities.where((e) => e['dpto'] == dept).toList();
        if (matches.isNotEmpty) {
          _mapController.move(LatLng(double.parse(matches[0]['latitud'].toString()), double.parse(matches[0]['longitud'].toString())), 8.0);
        }
      } else {
        _cities = [];
      }
    });
  }

  void _onCityChanged(String? city) {
    setState(() {
      _selectedCity = city;
      if (city != null) {
        final matches = _colombiaCities.where(
          (e) => e['dpto'] == _selectedDept && e['nom_mpio'] == city
        ).toList();
        if (matches.isNotEmpty) {
          try {
            final latStr = matches[0]['latitud'].toString().replaceAll(',', '.');
            final lngStr = matches[0]['longitud'].toString().replaceAll(',', '.');
            _mapController.move(LatLng(double.parse(latStr), double.parse(lngStr)), 12.0);
          } catch (e) {
            debugPrint("Error al parsear coordenadas de ciudad: $e");
          }
        }
      }
    });
  }

  Future<void> _fetchLogs() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/monitoring/logins'),
        headers: {
          'Authorization': 'Bearer ${ApiService().token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _loginLogs = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching logs: $e');
    }
  }

  Future<void> _terminateSession(int sessionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar esta sesión de forma remota? El usuario será desconectado inmediatamente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('TERMINAR'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(
        Uri.parse('${ApiService.baseUrl}/monitoring/sessions/$sessionId'),
        headers: {
          'Authorization': 'Bearer ${ApiService().token}',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesión terminada correctamente')),
        );
        _fetchLogs();
        setState(() {
          _selectedLog = null;
        });
      } else {
        final error = json.decode(response.body)['error'] ?? 'Error desconocido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  void _selectLog(dynamic log) {
    LatLng? location;

    setState(() {
      _selectedLog = log;
      
      if (log['city'] != null && log['city'].toString().isNotEmpty) {
        String logCity = log['city'].toString().toUpperCase();
        logCity = logCity.replaceAll(RegExp(r'[ÁÄÀÂ]'), 'A')
                         .replaceAll(RegExp(r'[ÉËÈÊ]'), 'E')
                         .replaceAll(RegExp(r'[ÍÏÌÎ]'), 'I')
                         .replaceAll(RegExp(r'[ÓÖÒÔ]'), 'O')
                         .replaceAll(RegExp(r'[ÚÜÙÛ]'), 'U');

        final cityData = _colombiaCities.firstWhere(
          (c) {
            String cName = c['nom_mpio'].toString().toUpperCase();
            cName = cName.replaceAll(RegExp(r'[ÁÄÀÂ]'), 'A')
                         .replaceAll(RegExp(r'[ÉËÈÊ]'), 'E')
                         .replaceAll(RegExp(r'[ÍÏÌÎ]'), 'I')
                         .replaceAll(RegExp(r'[ÓÖÒÔ]'), 'O')
                         .replaceAll(RegExp(r'[ÚÜÙÛ]'), 'U');
            return cName == logCity || logCity.contains(cName) || cName.contains(logCity);
          },
          orElse: () => null
        );
        if (cityData != null) {
          _selectedDept = cityData['dpto'].toString();
          
          final newCities = _colombiaCities
              .where((e) => e['dpto'] == _selectedDept)
              .map((e) => e['nom_mpio'].toString())
              .toSet()
              .toList();
          newCities.sort();
          _cities = newCities;
          
          _selectedCity = cityData['nom_mpio'].toString();

          try {
            final latStr = cityData['latitud'].toString().replaceAll(',', '.');
            final lngStr = cityData['longitud'].toString().replaceAll(',', '.');
            location = LatLng(double.parse(latStr), double.parse(lngStr));
          } catch (e) {
            debugPrint("Error parsing city coordinates: $e");
          }
        }
      }
    });

    if (log['latitude'] != null && log['longitude'] != null && log['latitude'].toString().isNotEmpty && log['longitude'].toString().isNotEmpty) {
      try {
        final lat = double.parse(log['latitude'].toString());
        final lng = double.parse(log['longitude'].toString());
        location = LatLng(lat, lng);
      } catch (e) {
        debugPrint("Error parsing log coordinates: $e");
      }
    }

    if (location != null) {
      _mapController.move(location!, 14.0);
    }
  }

  Future<void> _onMapTapped(LatLng point) async {
    setState(() => _isLoading = true);
    
    String nombre = 'Nueva Sucursal';
    String direccion = 'Ubicación sin dirección';
    String ciudad = _selectedCity ?? '';
    String departamento = _selectedDept ?? '';
    String pais = 'Colombia';

    try {
      // Reverse Geocoding with Nominatim
      final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&zoom=18&addressdetails=1');
      final response = await http.get(url, headers: {'User-Agent': 'BellezaLonApp'});
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final addr = data['address'] ?? {};
        
        direccion = data['display_name'] ?? direccion;
        ciudad = addr['city'] ?? addr['town'] ?? addr['village'] ?? ciudad;
        departamento = addr['state'] ?? departamento;
        pais = addr['country'] ?? pais;
        
        // Use house number/road if available for a cleaner name
        if (addr['road'] != null) {
          nombre = 'Sucursal ${addr['road']}';
        }
      }
    } catch (e) {
      debugPrint('Error reverse geocoding: $e');
    }

    final data = {
      'nombre': nombre,
      'departamento': departamento,
      'ciudad': ciudad,
      'barrio': '',
      'direccion': direccion,
      'latitud': point.latitude,
      'longitud': point.longitude,
      'pais': pais,
    };

    final res = await _api.createSucursal(data);
    
    setState(() => _isLoading = false);
    
    if (res != null) {
      _fetchSucursales();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sucursal guardada: $nombre')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar automáticamente')),
      );
    }
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Servicio de ubicación desactivado')));
        return;
      }

      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) return;
      }

      final position = await geo.Geolocator.getCurrentPosition();
      _mapController.move(LatLng(position.latitude, position.longitude), 15.0);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _deleteSucursal(dynamic sucursalId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Sucursal'),
        content: const Text('¿Estás seguro de eliminar esta sucursal?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _api.deleteSucursal(int.parse(sucursalId.toString()));
      if (success) {
        _fetchSucursales();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sucursal eliminada')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al eliminar la sucursal')));
      }
    }
  }

  Future<void> _showCreateSucursalDialog({dynamic sucursal, LatLng? initialLocation}) async {
    final nombreController = TextEditingController(text: sucursal?['nombre']);
    final paisController = TextEditingController(text: sucursal?['pais'] ?? 'Colombia');
    final barrioController = TextEditingController(text: sucursal?['barrio']);
    final dirController = TextEditingController(text: sucursal?['direccion']);

    String? tempDept = sucursal?['departamento'];
    String? tempCity = sucursal?['ciudad'];
    List<String> tempCities = [];
    if (tempDept != null) {
      tempCities = _colombiaCities.where((e) => e['dpto'] == tempDept).map((e) => e['nom_mpio'].toString()).toSet().toList()..sort();
    }


    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Agregar Sucursal'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre Sucursal', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: paisController,
                      decoration: const InputDecoration(labelText: 'País', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: tempDept,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Departamento', border: OutlineInputBorder()),
                      items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          tempDept = val;
                          tempCity = null;
                          if (val != null) {
                            tempCities = _colombiaCities.where((e) => e['dpto'] == val).map((e) => e['nom_mpio'].toString()).toSet().toList()..sort();
                          } else {
                            tempCities = [];
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: tempCity,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Ciudad', border: OutlineInputBorder()),
                      items: tempCities.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (val) => setStateDialog(() => tempCity = val),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: barrioController,
                      decoration: const InputDecoration(labelText: 'Barrio', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dirController,
                      decoration: const InputDecoration(labelText: 'Dirección', border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
                ElevatedButton(
                  onPressed: () async {
                    if (nombreController.text.isEmpty || tempDept == null || tempCity == null || barrioController.text.isEmpty || dirController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Llene todos los campos')));
                      return;
                    }

                    setStateDialog(() => _isLoading = true);

                    double? lat, lng;
                    
                    if (initialLocation != null) {
                      lat = initialLocation.latitude;
                      lng = initialLocation.longitude;
                    } else if (sucursal != null && sucursal['latitud'] != null) {
                       // Keep existing if editing and not changed via map (though edit uses dialog)
                       lat = double.tryParse(sucursal['latitud'].toString());
                       lng = double.tryParse(sucursal['longitud'].toString());
                    }
                    
                    // 1. Try Nominatim Geocoding for accuracy if NO initialLocation (map pick)
                    if (lat == null && lng == null) {
                      final String address = '${dirController.text}, ${barrioController.text}, $tempCity, $tempDept, ${paisController.text}';
                      try {
                        final geoUrl = Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1');
                        final geoRes = await http.get(geoUrl, headers: {'User-Agent': 'BellezaSalonApp/1.0'});
                        if (geoRes.statusCode == 200) {
                          final List results = jsonDecode(geoRes.body);
                          if (results.isNotEmpty) {
                            lat = double.tryParse(results[0]['lat']);
                            lng = double.tryParse(results[0]['lon']);
                          }
                        }
                      } catch (e) {
                        debugPrint("Nominatim error: $e");
                      }
                    }

                    // 2. Fallback to city data if nominatim fails and NO explicit pick
                    if (lat == null || lng == null) {
                      final cityData = _colombiaCities.firstWhere(
                        (c) => c['dpto'] == tempDept && c['nom_mpio'] == tempCity,
                        orElse: () => null
                      );
                      if (cityData != null) {
                        try {
                          lat = double.parse(cityData['latitud'].toString().replaceAll(',', '.'));
                          lng = double.parse(cityData['longitud'].toString().replaceAll(',', '.'));
                        } catch (_) {}
                      }
                    }

                    final data = {
                      'nombre': nombreController.text,
                      'pais': paisController.text,
                      'departamento': tempDept,
                      'ciudad': tempCity,
                      'barrio': barrioController.text,
                      'direccion': dirController.text,
                      'latitud': lat,
                      'longitud': lng,
                    };

                    bool success = false;
                    if (sucursal != null) {
                      success = await _api.updateSucursal(int.parse(sucursal['id'].toString()), data);
                    } else {
                      final res = await _api.createSucursal(data);
                      success = res != null;
                    }

                    setStateDialog(() => _isLoading = false);

                    if (success) {
                      _fetchSucursales();
                      setState(() => _pickedLocation = null);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sucursal guardada')));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar')));
                    }
                  },
                  child: Text(sucursal != null ? 'ACTUALIZAR' : 'GUARDAR'),
                ),
              ],
            );
          }
        );
      }
    ).then((_) {
      // Clear picked location if they just closed the dialog without saving
      if (_pickedLocation != null && sucursal == null) {
         setState(() => _pickedLocation = null);
      }
    });
  }

  List<dynamic> get _filteredLogs {
    return _loginLogs.where((log) {
      if (_selectedDept != null) {
        if (log['city'] == null) return false;
        String logCity = log['city'].toString().toUpperCase();
        logCity = logCity.replaceAll(RegExp(r'[ÁÄÀÂ]'), 'A')
                         .replaceAll(RegExp(r'[ÉËÈÊ]'), 'E')
                         .replaceAll(RegExp(r'[ÍÏÌÎ]'), 'I')
                         .replaceAll(RegExp(r'[ÓÖÒÔ]'), 'O')
                         .replaceAll(RegExp(r'[ÚÜÙÛ]'), 'U');
        
        final cityData = _colombiaCities.firstWhere(
          (c) {
            String cName = c['nom_mpio'].toString().toUpperCase();
            cName = cName.replaceAll(RegExp(r'[ÁÄÀÂ]'), 'A')
                         .replaceAll(RegExp(r'[ÉËÈÊ]'), 'E')
                         .replaceAll(RegExp(r'[ÍÏÌÎ]'), 'I')
                         .replaceAll(RegExp(r'[ÓÖÒÔ]'), 'O')
                         .replaceAll(RegExp(r'[ÚÜÙÛ]'), 'U');
            return cName == logCity || logCity.contains(cName) || cName.contains(logCity);
          },
          orElse: () => null
        );

        if (cityData == null || cityData['dpto'] != _selectedDept) return false;
        
        if (_selectedCity != null) {
            String selCity = _selectedCity!.toUpperCase();
            selCity = selCity.replaceAll(RegExp(r'[ÁÄÀÂ]'), 'A')
                         .replaceAll(RegExp(r'[ÉËÈÊ]'), 'E')
                         .replaceAll(RegExp(r'[ÍÏÌÎ]'), 'I')
                         .replaceAll(RegExp(r'[ÓÖÒÔ]'), 'O')
                         .replaceAll(RegExp(r'[ÚÜÙÛ]'), 'U');
          return logCity == selCity || logCity.contains(selCity) || selCity.contains(logCity);
        }
      }
      return true;
    }).toList();
  }

  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list, size: 20),
              const SizedBox(width: 8),
              Text('Filtros Geográficos', style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedDept,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Departamento',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Todos')),
              ..._departments.map((d) => DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis))),
            ],
            onChanged: _onDeptChanged,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCity,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Ciudad/Municipio',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Todas')),
              ..._cities.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))),
            ],
            onChanged: _onCityChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Accesos')),
                  selected: !_isShowingSucursales,
                  onSelected: (val) {
                    if (val) setState(() => _isShowingSucursales = false);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Sucursales')),
                  selected: _isShowingSucursales,
                  onSelected: (val) {
                    if (val) setState(() => _isShowingSucursales = true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSucursalesList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () => _showCreateSucursalDialog(),
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Guardar Sucursal'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
          ),
        ),
        Expanded(
          child: _sucursales.isEmpty 
            ? const Center(child: Text('No hay sucursales guardadas'))
            : ListView.separated(
                itemCount: _sucursales.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final suc = _sucursales[index];
                  return ListTile(
                    dense: true,
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 16,
                      child: Icon(Icons.store, color: Colors.white, size: 16),
                    ),
                    title: Text(suc['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('${suc['barrio']} - ${suc['direccion']}\n${suc['ciudad']}, ${suc['pais'] ?? 'Colombia'}', style: const TextStyle(fontSize: 11)),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => _showCreateSucursalDialog(sucursal: suc)),
                        IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () => _deleteSucursal(suc['id'])),
                      ],
                    ),
                    onTap: () {
                      if (suc['latitud'] != null && suc['longitud'] != null) {
                        final lat = double.tryParse(suc['latitud'].toString());
                        final lng = double.tryParse(suc['longitud'].toString());
                        if (lat != null && lng != null) {
                          _mapController.move(LatLng(lat, lng), 15.0);
                        }
                      }
                      final isMobile = MediaQuery.of(context).size.width < 700;
                      if (isMobile) setState(() => _showSessions = false);
                    },
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _buildLogsList() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_filteredLogs.isEmpty) return const Center(child: Text('No hay accesos registrados'));
    
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _filteredLogs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final log = _filteredLogs[index];
        final isSelected = _selectedLog == log;
        final date = DateTime.parse(log['login_at']);
        final isActive = log['is_active'] != null ? (int.tryParse(log['is_active'].toString()) != 0) : true;
        
        return ListTile(
          selected: isSelected,
          dense: true,
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : (isActive ? Colors.green.shade50 : Colors.grey.shade100),
            child: Icon(
              isActive ? Icons.login : Icons.logout, 
              size: 14, 
              color: isSelected ? Colors.white : (isActive ? Colors.green : Colors.grey),
            ),
          ),
          title: Text(log['username'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<SettingsProvider>(
                builder: (context, settings, _) => Text(
                  '${formatDateTime(date, settings.timeFormat)} • ${log['ip_address']}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ),
              if (log['city'] != null)
                Text(log['city'], style: TextStyle(fontSize: 11, color: Colors.blue.shade700)),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isActive ? 'ACTIVA' : 'CERRADA',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? Colors.green : Colors.grey.shade700),
                ),
              ),
            ],
          ),
          onTap: () {
            _selectLog(log);
            // On mobile, collapse sessions after selecting
            final isMobile = MediaQuery.of(context).size.width < 700;
            if (isMobile) setState(() => _showSessions = false);
          },
        );
      },
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(4.5709, -74.2973),
        initialZoom: 6.0,
        onTap: (tapPosition, point) => _onMapTapped(point),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          userAgentPackageName: 'com.bellezalon.app',
          tileProvider: NetworkTileProvider(),
        ),
        MarkerLayer(
          markers: [
            // 1. Session Markers
            ..._filteredLogs.map((log) {
              LatLng? point;
              bool isPrecise = false;

              if (log['latitude'] != null && log['longitude'] != null && 
                  log['latitude'].toString().isNotEmpty && log['longitude'].toString().isNotEmpty) {
                try {
                  point = LatLng(double.parse(log['latitude'].toString()), double.parse(log['longitude'].toString()));
                  isPrecise = true;
                } catch (_) {}
              }

              if (point == null && log['city'] != null && log['city'].toString().isNotEmpty) {
                final logCity = log['city'].toString().toUpperCase();
                final cityData = _colombiaCities.firstWhere(
                  (c) => c['nom_mpio'].toString().toUpperCase() == logCity || 
                         logCity.contains(c['nom_mpio'].toString().toUpperCase()),
                  orElse: () => null
                );
                if (cityData != null) {
                  try {
                    final latStr = cityData['latitud'].toString().replaceAll(',', '.');
                    final lngStr = cityData['longitud'].toString().replaceAll(',', '.');
                    point = LatLng(double.parse(latStr), double.parse(lngStr));
                  } catch (_) {}
                }
              }

              if (point == null) return null;
              final isActive = log['is_active'] != null ? (int.tryParse(log['is_active'].toString()) != 0) : true;
              
              return Marker(
                point: point,
                width: 45,
                height: 45,
                child: GestureDetector(
                  onTap: () => _selectLog(log),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        isPrecise ? Icons.location_on : Icons.location_city,
                        color: _selectedLog == log 
                          ? Colors.red 
                          : (isActive ? (isPrecise ? Colors.blue : Colors.blueGrey) : Colors.grey),
                        size: isPrecise ? 45 : 35,
                      ),
                      if (isActive && _selectedLog != log)
                        Positioned(
                          top: isPrecise ? 5 : 8,
                          right: isPrecise ? 5 : 8,
                          child: Container(
                            width: 10, height: 10,
                            decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).whereType<Marker>(),

            // 2. Sucursal Markers
            ..._sucursales.map((suc) {
              if (suc['latitud'] == null || suc['longitud'] == null) return null;
              final lat = double.tryParse(suc['latitud'].toString());
              final lng = double.tryParse(suc['longitud'].toString());
              if (lat == null || lng == null) return null;

              return Marker(
                point: LatLng(lat, lng),
                width: 45,
                height: 45,
                child: GestureDetector(
                  onTap: () => _mapController.move(LatLng(lat, lng), 15.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.store, color: Colors.purple, size: 40),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          color: Colors.white70,
                          child: Text(suc['nombre'], style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.purple)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).whereType<Marker>(),

            // 3. Picked Marker (Visual feedback while geocoding - Optional, but keeping for consistency)
            if (_pickedLocation != null)
              Marker(
                point: _pickedLocation!,
                width: 45,
                height: 45,
                child: const Icon(Icons.add_location_alt, color: Colors.orange, size: 45),
              ),
          ],
        ),
      ],
    ),
    Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        heroTag: 'gps_btn',
        onPressed: _moveToCurrentLocation,
        mini: true,
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    ),
  ],
);
  }

  Widget _buildBottomBar() {
    if (_selectedLog == null) return const SizedBox.shrink();
    final isActive = double.tryParse(_selectedLog['is_active']?.toString() ?? '1') != 0;
    if (!isActive) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sesión: ${_selectedLog['username']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('${_selectedLog['ip_address']} - ${_selectedLog['city'] ?? "?"}', style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _terminateSession(int.parse(_selectedLog['id'].toString())),
            icon: const Icon(Icons.exit_to_app, size: 16),
            label: const Text('CERRAR', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade100,
              foregroundColor: Colors.red.shade900,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() => _selectedLog = null),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 700;
    final activeSessions = _filteredLogs.where((l) => int.tryParse(l['is_active']?.toString() ?? '0') != 0).length;

    return Scaffold(
      body: isDesktop
          // ── DESKTOP: side-by-side ──
          ? Row(
              children: [
                SizedBox(
                  width: 320,
                  child: Column(
                    children: [
                      _buildFilterPanel(),
                      const Divider(height: 1),
                      Expanded(child: _isShowingSucursales ? _buildSucursalesList() : _buildLogsList()),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade300))),
                    child: _buildMap(),
                  ),
                ),
              ],
            )
          // ── MOBILE: map full + collapsible sessions ──
          : Stack(
              children: [
                Positioned.fill(child: _buildMap()),
                // Toggle button
                Positioned(
                  top: 12,
                  left: 12,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(28),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () => setState(() => _showSessions = !_showSessions),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_showSessions ? Icons.map : Icons.people, size: 18, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              _showSessions ? 'Ver Mapa' : 'Sesiones ($activeSessions)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Collapsible sessions panel
                if (_showSessions)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          _buildFilterPanel(),
                          const Divider(height: 1),
                          Expanded(child: _isShowingSucursales ? _buildSucursalesList() : _buildLogsList()),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
      bottomSheet: _buildBottomBar(),
    );
  }
}
