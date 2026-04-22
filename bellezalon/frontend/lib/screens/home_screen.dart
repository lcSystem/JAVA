import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ApiService _api = ApiService();
  late TabController _tabController;
  final MapController _mapController = MapController();

  List<dynamic> _galleryImages = [];
  List<dynamic> _sucursales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _api.getGalleryImages(),
        _api.getSucursales(),
      ]);
      setState(() {
        _galleryImages = results[0];
        _sucursales = results[1];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading home data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      final bytes = await result.readAsBytes();
      final filename = result.name;

      final descController = TextEditingController();
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Añadir a Galería'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(bytes, height: 150, fit: BoxFit.cover),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (Opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('SUBIR'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        setState(() => _isLoading = true);
        final res = await _api.uploadGalleryImage(bytes, filename, descController.text);
        if (res != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagen subida con éxito')));
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al subir la imagen')));
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _deleteImage(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Imagen'),
        content: const Text('¿Estás seguro de eliminar esta imagen de la galería?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ELIMINAR'),
          ),
        ],
      )
    );

    if (confirm == true) {
      final res = await _api.deleteGalleryImage(id);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagen eliminada')));
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al eliminar la imagen')));
      }
    }
  }

  void _openFullScreen(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
          body: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: _galleryImages.length,
            itemBuilder: (context, index) {
              final img = _galleryImages[index];
              final url = '${ApiService.assetsBaseUrl}${img['image_path']}';
              return InteractiveViewer(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGallery() {
    if (_galleryImages.isEmpty) {
      return const Center(child: Text('La galería está vacía'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: _galleryImages.length,
      itemBuilder: (context, index) {
        final img = _galleryImages[index];
        final url = '${ApiService.assetsBaseUrl}${img['image_path']}';
        
        return GestureDetector(
          onTap: () => _openFullScreen(index),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover, errorWidget: (_, __, ___) => const Icon(Icons.broken_image)),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      img['description'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (_api.userRole == 'Administrador')
                  Positioned(
                    top: 4, right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 4)]),
                      onPressed: () => _deleteImage(int.parse(img['id'].toString())),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMap() {
    final List<Marker> markers = [];
    final List<LatLng> points = [];

    for (final suc in _sucursales) {
      if (suc['latitud'] == null || suc['longitud'] == null) continue;
      final lat = double.tryParse(suc['latitud'].toString());
      final lng = double.tryParse(suc['longitud'].toString());
      if (lat == null || lng == null) continue;

      final p = LatLng(lat, lng);
      points.add(p);

      markers.add(
        Marker(
          point: p,
          width: 80,
          height: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.store, color: Colors.purple, size: 35),
              Container(
                padding: const EdgeInsets.all(2),
                color: Colors.white70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(suc['nombre'], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    Text('${suc['ciudad']}, ${suc['pais'] ?? 'Colombia'}', style: const TextStyle(fontSize: 7), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final hasPoints = points.isNotEmpty;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: hasPoints ? points.first : const LatLng(4.5709, -74.2973),
        initialZoom: hasPoints ? 12.0 : 6.0,
        initialCameraFit: hasPoints && points.length > 1
            ? CameraFit.bounds(bounds: LatLngBounds.fromPoints(points), padding: const EdgeInsets.all(40))
            : null,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          userAgentPackageName: 'com.bellezalon.app',
          tileProvider: NetworkTileProvider(),
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight),
        child: ColoredBox(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(icon: Icon(Icons.photo_library), text: 'Galería'),
                Tab(icon: Icon(Icons.map), text: 'Nuestras Sucursales'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGallery(),
          _buildMap(),
        ],
      ),
      floatingActionButton: _api.userRole == 'Administrador' 
        ? FloatingActionButton(
            onPressed: _uploadImage,
            child: const Icon(Icons.add_a_photo),
            tooltip: 'Subir Foto a la Galería',
          )
        : null,
    );
  }
}
