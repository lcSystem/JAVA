import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/settings_provider.dart';
import '../services/api_service.dart';
import '../utils/formatters.dart';

class ServicioScreen extends StatefulWidget {
  const ServicioScreen({super.key});
  @override
  State<ServicioScreen> createState() => _ServicioScreenState();
}

class _ServicioScreenState extends State<ServicioScreen> {
  List<dynamic> _servicios = [];
  List<dynamic> _filtrados = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    _servicios = await ApiService().getServicios();
    _filtrados = List.from(_servicios);
    _searchCtrl.clear();
    setState(() => _loading = false);
  }

  void _filter(String query) {
    setState(() {
      _filtrados = _servicios.where((s) =>
        (s['nombre'] ?? '').toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  void _showForm({Map<String, dynamic>? svc}) {
    final nombreCtrl = TextEditingController(text: svc?['nombre'] ?? '');
    final descCtrl = TextEditingController(text: svc?['descripcion'] ?? '');
    final precioCtrl = TextEditingController(text: svc?['precio']?.toString() ?? '');
    final durCtrl = TextEditingController(text: svc?['duracion_minutos']?.toString() ?? '30');
    final depositCtrl = TextEditingController(text: svc?['deposit_amount']?.toString() ?? '0');
    List<dynamic> localImages = svc != null ? List<dynamic>.from(svc?['imagenes'] ?? []) : [];
    
    List<String> selectedTaxes = [];
    if (svc?['taxes'] != null) {
      try {
        final decoded = jsonDecode(svc!['taxes']);
        if (decoded is List) {
          selectedTaxes = List<String>.from(decoded);
        }
      } catch (_) {}
    }

    bool isUploading = false;

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setDialogState) {
      return AlertDialog(
        title: Text(svc == null ? 'Nuevo Servicio' : 'Editar Servicio'),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre*', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()), maxLines: 2),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextField(controller: precioCtrl, decoration: const InputDecoration(labelText: 'Precio*', border: OutlineInputBorder(), prefixText: '\$ '), keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: durCtrl, decoration: const InputDecoration(labelText: 'Duración (min)', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
              ]),
              const SizedBox(height: 12),
              TextField(controller: depositCtrl, decoration: const InputDecoration(labelText: 'Depósito Requerido (\$)', border: OutlineInputBorder(), prefixText: '\$ ', helperText: 'Monto que el cliente debe pagar para reservar.'), keyboardType: TextInputType.number),
              
              if (Provider.of<SettingsProvider>(context, listen: false).activeTaxes.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const Text('Impuestos Aplicables', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                ...Provider.of<SettingsProvider>(context, listen: false).activeTaxes.map((tax) {
                  final name = tax['name'] as String;
                  final isInv = tax['invisible'] == true;
                  return CheckboxListTile(
                    title: Text(name),
                    subtitle: Text('${tax['rate']}% ${isInv ? '(Suma al precio)' : '(Suma al total)'}'),
                    value: selectedTaxes.contains(name),
                    onChanged: (val) {
                      setDialogState(() {
                        if (val == true) selectedTaxes.add(name);
                        else selectedTaxes.remove(name);
                      });
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  );
                }),
              ],
              
              if (svc != null) ...[
                const SizedBox(height: 24),
                const Text('Catálogo de Imágenes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                if (localImages.isEmpty)
                  const Text('No hay imágenes registradas para este servicio.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                if (localImages.isNotEmpty)
                  Wrap(
                    spacing: 12, runSpacing: 12,
                    children: localImages.map((img) {
                      final url = '${ApiService.assetsBaseUrl}${img['image_url']}';
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(imageUrl: url, width: 90, height: 90, fit: BoxFit.cover, errorWidget: (_,__,___) => Container(width: 90, height: 90, color: Colors.grey[200], child: const Icon(Icons.image_not_supported))),
                          ),
                          Positioned(
                            top: -6, right: -6,
                            child: GestureDetector(
                              onTap: () async {
                                final api = ApiService();
                                final ok = await api.deleteServiceImage(img['id']);
                                if (ok) {
                                  setDialogState(() => localImages.remove(img));
                                  _load(); // Refresh underlying view
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: const Icon(Icons.close, color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ]
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: isUploading ? null : () async {
                    final settings = Provider.of<SettingsProvider>(context, listen: false);
                    if (localImages.length >= settings.maxServiceImages) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.orange, content: Text('Solo se permiten ${settings.maxServiceImages} imágenes por servicio. Para cambiar este límite visita la Configuración administrativa.')));
                      return;
                    }
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setDialogState(() => isUploading = true);
                      final api = ApiService();
                      final bytes = await image.readAsBytes();
                      final result = await api.uploadServiceImage(svc['id'], bytes, image.name);
                      if (result['success'] == true) {
                        setDialogState(() {
                          localImages.add({'id': result['id'], 'image_url': result['url']});
                        });
                        _load(); // Update underlying list
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(result['error'] ?? 'Error fatal al subir imagen.')));
                      }
                      setDialogState(() => isUploading = false);
                    }
                  },
                  icon: isUploading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add_photo_alternate),
                  label: const Text('Agregar Imagen'),
                )
              ]
            ]),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
          FilledButton(onPressed: () async {
            if (nombreCtrl.text.isEmpty || precioCtrl.text.isEmpty) return;
            final data = {
              'nombre': nombreCtrl.text,
              'descripcion': descCtrl.text,
              'precio': double.tryParse(precioCtrl.text) ?? 0.0,
              'duracion_minutos': int.tryParse(durCtrl.text) ?? 30,
              'taxes': selectedTaxes,
              'deposit_amount': double.tryParse(depositCtrl.text) ?? 0.0
            };
            try {
              if (svc == null) {
                await ApiService().createServicio(data);
              } else {
                await ApiService().updateServicio(svc['id'], data);
              }
              Navigator.pop(ctx); _load();
            } on OfflineException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]),
                backgroundColor: Colors.red[700],
              ));
            }
          }, child: Text(svc == null ? 'Crear' : 'Actualizar')),
        ],
      );
    }));
  }

  void _showServiceCatalog(BuildContext context, Map<String, dynamic> svc, Color primary) {
    final List<dynamic> localImages = List<dynamic>.from(svc['imagenes'] ?? []);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Stack(
                children: [
                  ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      // Galería fotográfica Hero
                      SizedBox(
                        height: 350,
                        child: localImages.isEmpty
                            ? Container(
                                color: primary.withOpacity(0.05),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.photo_size_select_actual_outlined, size: 80, color: primary.withOpacity(0.3)),
                                      const SizedBox(height: 12),
                                      Text('Sin galería visual', style: TextStyle(color: primary.withOpacity(0.6))),
                                    ],
                                  ),
                                ),
                              )
                            : PageView.builder(
                                itemCount: localImages.length,
                                itemBuilder: (context, index) {
                                  final img = localImages[index];
                                  final url = '${ApiService.assetsBaseUrl}${img['image_url']}';
                                  return CachedNetworkImage(
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorWidget: (_, __, ___) => Container(color: primary.withOpacity(0.05), child: const Center(child: Icon(Icons.broken_image, size: 60, color: Colors.grey))),
                                  );
                                },
                              ),
                      ),
                      // Tarjeta de Contenido Flotante Estilizada
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(svc['nombre'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5, height: 1.2)),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                                    child: Text(formatCurrency(svc['precio']), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Icons.access_time_filled, color: Colors.grey[500], size: 18),
                                  const SizedBox(width: 6),
                                  Text('${svc['duracion_minutos']} minutos', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 20),
                                  if (svc['deposit_amount'] != null && (double.tryParse(svc['deposit_amount'].toString()) ?? 0) > 0) ...[
                                    Icon(Icons.lock_clock, color: Colors.orange[400], size: 18),
                                    const SizedBox(width: 6),
                                    Text('Depósito mínimo: ${formatCurrency(double.parse(svc['deposit_amount'].toString()))}', style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.w600)),
                                  ]
                                ],
                              ),
                              const SizedBox(height: 32),
                              const Text('Acerca del Servicio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Text(svc['descripcion'] ?? 'Sin descripción detallada.', style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87)),
                              const SizedBox(height: 100), // Padding extra para el botón
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Botón Fijo Abajo
                  Positioned(
                    left: 20, right: 20, bottom: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.9), blurRadius: 20, spreadRadius: 20)],
                      ),
                      child: Row(
                        children: [
                          if (ApiService().isAdmin) ...[
                            IconButton.filled(
                              onPressed: () {
                                Navigator.pop(context);
                                _showForm(svc: svc);
                              },
                              icon: const Icon(Icons.edit),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton.filled(
                              onPressed: () => _confirmDelete(context, svc),
                              icon: const Icon(Icons.delete),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, ingresa al Calendario para apartar este servicio.')));
                              },
                              icon: const Icon(Icons.calendar_month),
                              label: const Text('Agendar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              style: FilledButton.styleFrom(
                                backgroundColor: primary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botón Flotante para Cerrar Superior
                  Positioned(
                    top: 16, right: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> svc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar el servicio "${svc['nombre']}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              try {
                final ok = await ApiService().deleteServicio(svc['id']);
                if (mounted) {
                  Navigator.pop(ctx);
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Servicio eliminado correctamente'), backgroundColor: Colors.green));
                    _load();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al eliminar el servicio'), backgroundColor: Colors.red));
                  }
                }
              } on OfflineException catch (e) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]),
                  backgroundColor: Colors.red[700],
                ));
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [primary.withOpacity(0.1), Colors.transparent])),
          child: Column(children: [
            Row(children: [
              Icon(Icons.spa, color: primary, size: 28), const SizedBox(width: 12),
              Text('Servicios', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary)),
              const Spacer(),
              if (ApiService().isAdmin) FilledButton.icon(onPressed: () => _showForm(), icon: const Icon(Icons.add), label: const Text('Nuevo')),
              const SizedBox(width: 8),
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            ]),
            const SizedBox(height: 12),
            TextField(
              controller: _searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(hintText: 'Buscar servicio...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
            ),
          ]),
        ),
        Expanded(
          child: _loading ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 320, childAspectRatio: 1.4, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: _filtrados.length,
                itemBuilder: (_, i) {
                  final s = _filtrados[i];
                  return InkWell(
                    onTap: () => _showServiceCatalog(context, s, primary),
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.content_cut, color: primary, size: 20)),
                          const SizedBox(width: 10),
                          Expanded(child: Text(s['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis)),
                        ]),
                        const SizedBox(height: 8),
                        Text(s['descripcion'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
                        if (s['deposit_amount'] != null && (double.tryParse(s['deposit_amount'].toString()) ?? 0) > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('Depósito: ${formatCurrency(double.parse(s['deposit_amount'].toString()))}', style: const TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold)),
                          ),
                        const Spacer(),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(formatCurrency(s['precio']), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Text('${s['duracion_minutos']} min', style: const TextStyle(fontSize: 12, color: Colors.blue)),
                          ),
                        ]),
                      ]),
                    ),
                  ));
                },
              ),
        ),
      ]),
    );
  }
}
