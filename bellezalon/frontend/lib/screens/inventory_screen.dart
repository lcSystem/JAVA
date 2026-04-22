import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/offline_guard.dart';
import '../utils/formatters.dart';
import 'package:provider/provider.dart';
import '../services/settings_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<dynamic> _productos = [];
  List<dynamic> _filtrados = [];
  List<dynamic> _alertas = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final api = ApiService();
    final results = await Future.wait([api.getProductos(), api.getAlertasStock()]);
    _productos = results[0]; _alertas = results[1]; _filtrados = List.from(_productos);
    _searchCtrl.clear();
    setState(() => _loading = false);
  }

  void _filter(String query) {
    setState(() {
      _filtrados = _productos.where((p) =>
        (p['nombre'] ?? '').toString().toLowerCase().contains(query.toLowerCase()) ||
        (p['categoria'] ?? '').toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  void _showForm({Map<String, dynamic>? prod}) {
    final nombreCtrl = TextEditingController(text: prod?['nombre'] ?? '');
    final descCtrl = TextEditingController(text: prod?['descripcion'] ?? '');
    final catCtrl = TextEditingController(text: prod?['categoria'] ?? 'general');
    final pcCtrl = TextEditingController(text: prod?['precio_compra']?.toString() ?? '');
    final pvCtrl = TextEditingController(text: prod?['precio_venta']?.toString() ?? '');
    final stockCtrl = TextEditingController(text: prod?['stock']?.toString() ?? '0');
    final minCtrl = TextEditingController(text: prod?['stock_minimo']?.toString() ?? '5');
    
    List<String> selectedTaxes = [];
    if (prod?['taxes'] != null) {
      try {
        final decoded = jsonDecode(prod!['taxes']);
        if (decoded is List) {
          selectedTaxes = List<String>.from(decoded);
        }
      } catch (_) {}
    }

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setDState) {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final availableTaxes = settings.activeTaxes;
      return AlertDialog(
      title: Text(prod == null ? 'Nuevo Producto' : 'Editar Producto'),
      content: SizedBox(width: 400, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre*', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: TextField(controller: pcCtrl, decoration: const InputDecoration(labelText: 'P. Compra', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: pvCtrl, decoration: const InputDecoration(labelText: 'P. Venta*', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: TextField(controller: stockCtrl, decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: minCtrl, decoration: const InputDecoration(labelText: 'Stock Mínimo', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
        ]),
        if (availableTaxes.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Divider(),
          const Text('Impuestos Aplicables', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          ...availableTaxes.map((tax) {
            final name = tax['name'] as String;
            final isInv = tax['invisible'] == true;
            return CheckboxListTile(
              title: Text(name),
              subtitle: Text('${tax['rate']}% ${isInv ? '(Suma al precio)' : '(Suma al total)'}'),
              value: selectedTaxes.contains(name),
              onChanged: (val) {
                setDState(() {
                  if (val == true) selectedTaxes.add(name);
                  else selectedTaxes.remove(name);
                });
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ]))),
      actions: [
        if (prod != null)
          TextButton.icon(
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirmar Eliminación'),
                  content: const Text('¿Estás seguro de que deseas eliminar este producto?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                try {
                  await ApiService().deleteProducto(prod['id']);
                  if (!context.mounted) return;
                  Navigator.pop(ctx); _load();
                } on OfflineException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
                }
              }
            },
          ),
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        FilledButton(onPressed: () async {
          if (nombreCtrl.text.isEmpty || pvCtrl.text.isEmpty) return;
          final data = {
            'nombre': nombreCtrl.text, 
            'descripcion': descCtrl.text, 
            'categoria': catCtrl.text, 
            'precio_compra': double.tryParse(pcCtrl.text) ?? 0, 
            'precio_venta': double.tryParse(pvCtrl.text) ?? 0, 
            'stock': int.tryParse(stockCtrl.text) ?? 0, 
            'stock_minimo': int.tryParse(minCtrl.text) ?? 5, 
            'taxes': selectedTaxes,
            'estado': 'activo'
          };
          try {
            if (prod == null) {
              await ApiService().createProducto(data);
            } else {
              await ApiService().updateProducto(prod['id'], data);
            }
            if (!context.mounted) return;
            Navigator.pop(ctx); _load();
          } on OfflineException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
          }
        }, child: Text(prod == null ? 'Crear' : 'Guardar')),
      ],
    ); }));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.teal.withOpacity(0.1), Colors.transparent])),
          child: Column(children: [
            Row(children: [
              const Icon(Icons.inventory_2, color: Colors.teal, size: 28), const SizedBox(width: 12),
              Expanded(child: Text('Inventario', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary))),
              if (!isMobile) ...[
                if (_alertas.isNotEmpty) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.warning, size: 16, color: Colors.red), const SizedBox(width: 4), Text('${_alertas.length} stock bajo', style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold))]),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(onPressed: () => _showForm(), icon: const Icon(Icons.add), label: const Text('Nuevo')),
                const SizedBox(width: 8),
              ],
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            ]),
            if (isMobile) ...[
              const SizedBox(height: 12),
              if (_alertas.isNotEmpty) Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.warning, size: 16, color: Colors.red), const SizedBox(width: 4), Text('${_alertas.length} productos con stock bajo', style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold))]),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(onPressed: () => _showForm(), icon: const Icon(Icons.add), label: const Text('Nuevo'))
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(hintText: 'Buscar producto...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
            ),
          ]),
        ),
        Expanded(
          child: _loading ? const Center(child: CircularProgressIndicator())
            : _filtrados.isEmpty ? Center(child: Text('No se encontraron productos', style: TextStyle(color: Colors.grey[500])))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filtrados.length,
                itemBuilder: (_, i) {
                  final p = _filtrados[i];
                  final stock = p['stock'] ?? 0;
                  final minStock = p['stock_minimo'] ?? 5;
                  final isBajo = stock <= minStock;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(backgroundColor: isBajo ? Colors.red.withOpacity(0.15) : Colors.teal.withOpacity(0.15), child: Icon(Icons.inventory, color: isBajo ? Colors.red : Colors.teal)),
                      title: Text(p['nombre'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${p['categoria']} • Venta: ${formatCurrency(p['precio_venta'])}'),
                        const SizedBox(height: 4),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: isBajo ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Text('Stock: $stock ${isBajo ? '⚠️ BAJO' : '✅'}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isBajo ? Colors.red : Colors.green)),
                          ),
                          const SizedBox(width: 8),
                          Text('Mín: $minStock', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        ]),
                      ]),
                      trailing: Text(formatCurrency(p['precio_venta']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primary)),
                    ),
                  );
                },
              ),
        ),
      ]),
    );
  }
}
