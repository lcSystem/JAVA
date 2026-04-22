import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../utils/offline_guard.dart';
import '../services/settings_provider.dart';
import '../utils/formatters.dart';
import 'invoice_preview_screen.dart';
import '../services/payments/payment_service.dart';

class SalesScreen extends StatefulWidget {
  final int? initialClienteId;
  final int? initialServicioId;
  final int? initialCitaId;

  const SalesScreen({super.key, this.initialClienteId, this.initialServicioId, this.initialCitaId});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<dynamic> _ventas = [];
  List<dynamic> _filtradas = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() { 
    super.initState(); 
    _load().then((_) {
      if (widget.initialClienteId != null && widget.initialServicioId != null) {
        _showCrearVenta(
          prefilledClienteId: widget.initialClienteId, 
          prefilledServicioId: widget.initialServicioId,
          prefilledCitaId: widget.initialCitaId
        );
      }
    });
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _ventas = await ApiService().getVentas();
    _filtradas = List.from(_ventas);
    _searchCtrl.clear();
    setState(() => _loading = false);
  }

  void _filter(String query) {
    setState(() {
      _filtradas = _ventas.where((v) =>
        (v['numero_factura'] ?? '').toString().toLowerCase().contains(query.toLowerCase()) ||
        (v['cliente_nombre'] ?? '').toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  void _showCrearVenta({int? prefilledClienteId, int? prefilledServicioId, int? prefilledCitaId}) async {
    final api = ApiService();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final users = await api.getUsers();
    final clientes = users.where((u) => u['role_id'].toString() == '3' && u['estado'] == 'activo').toList();
    final servicios = await api.getServicios();
    final productos = await api.getProductos();
    
    if (!mounted) return;

    final bool taxEnabled = settings.isTaxEnabled;
    
    int? clienteId = prefilledClienteId;
    String? servicioId = prefilledServicioId?.toString();
    String? productoId;
    String type = prefilledServicioId != null ? 'servicio' : 'servicio';
    double subtotal = 0;
    int cantidad = 1;
    final notaCtrl = TextEditingController();
    String metodoPago = 'efectivo';

    // Initial value if prefilled
    if (prefilledServicioId != null) {
      try {
        final svc = servicios.firstWhere((s) => s['id'].toString() == prefilledServicioId.toString());
        final basePrice = double.tryParse(svc['precio'].toString()) ?? 0;
        
        List<String> assignedTaxes = [];
        if (svc['taxes'] != null) {
          try {
            final decoded = jsonDecode(svc['taxes']);
            if (decoded is List) assignedTaxes = List<String>.from(decoded);
          } catch (_) {}
        }
        subtotal = settings.calculatePriceWithInvisibleTaxes(basePrice, selectedTaxNames: assignedTaxes);
      } catch (_) {}
    }

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setDState) {
      final total = (subtotal * cantidad) * (1 + (settings.totalActiveTaxRate / 100));

      return AlertDialog(
        title: const Row(children: [Icon(Icons.point_of_sale, color: Colors.green), SizedBox(width: 8), Text('Nueva Venta')]),
        content: SizedBox(width: 420, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<int>(
            value: clienteId,
            decoration: const InputDecoration(labelText: 'Cliente*', border: OutlineInputBorder()),
            items: clientes.map<DropdownMenuItem<int>>((c) => DropdownMenuItem(
              value: int.tryParse(c['id'].toString()), 
              child: Text(c['full_name'] ?? c['username'] ?? 'Sin nombre')
            )).toList(),
            onChanged: (v) => clienteId = v,
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'servicio', label: Text('Servicio'), icon: Icon(Icons.spa)),
              ButtonSegment(value: 'producto', label: Text('Producto'), icon: Icon(Icons.inventory_2)),
            ],
            selected: {type},
            onSelectionChanged: (set) {
              setDState(() {
                type = set.first;
                servicioId = null;
                productoId = null;
                subtotal = 0;
              });
            },
          ),
          const SizedBox(height: 16),
          if (type == 'servicio')
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Seleccionar Servicio*', border: OutlineInputBorder()),
              value: servicioId,
              items: servicios.map<DropdownMenuItem<String>>((s) => DropdownMenuItem(value: s['id'].toString(), child: Text(s['nombre']))).toList(),
              onChanged: (v) { 
                servicioId = v; 
                final svc = servicios.firstWhere((s) => s['id'].toString() == v.toString()); 
                List<String> assignedTaxes = [];
                if (svc['taxes'] != null) {
                  try {
                    final decoded = jsonDecode(svc['taxes']);
                    if (decoded is List) assignedTaxes = List<String>.from(decoded);
                  } catch (_) {}
                }
                setDState(() { 
                  final basePrice = double.tryParse(svc['precio'].toString()) ?? 0;
                  subtotal = settings.calculatePriceWithInvisibleTaxes(basePrice, selectedTaxNames: assignedTaxes);
                }); 
              },
            )
          else
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Seleccionar Producto*', border: OutlineInputBorder()),
              value: productoId,
              items: productos.map<DropdownMenuItem<String>>((p) => DropdownMenuItem(value: p['id'].toString(), child: Text(p['nombre']))).toList(),
              onChanged: (v) { 
                productoId = v; 
                final prod = productos.firstWhere((p) => p['id'].toString() == v.toString()); 
                List<String> assignedTaxes = [];
                if (prod['taxes'] != null) {
                  try {
                    final decoded = jsonDecode(prod['taxes']);
                    if (decoded is List) assignedTaxes = List<String>.from(decoded);
                  } catch (_) {}
                }
                setDState(() { 
                  final basePrice = double.tryParse(prod['precio_venta'].toString()) ?? 0;
                  subtotal = settings.calculatePriceWithInvisibleTaxes(basePrice, selectedTaxNames: assignedTaxes);
                }); 
              },
            ),
          if (type == 'producto') ...[
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Cantidad', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (v) => setDState(() => cantidad = int.tryParse(v) ?? 1),
            ),
          ],
          const SizedBox(height: 12),
          TextField(controller: notaCtrl, decoration: const InputDecoration(labelText: 'Notas', border: OutlineInputBorder()), maxLines: 2),
          const SizedBox(height: 16),
          const Text('Medio de Pago*', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'efectivo', label: Text('Efectivo'), icon: Icon(Icons.money)),
              ButtonSegment(value: 'transaccion', label: Text('Transacción'), icon: Icon(Icons.payment)),
            ],
            selected: {metodoPago},
            onSelectionChanged: (set) => setDState(() => metodoPago = set.first),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Subtotal${cantidad > 1 ? " (x$cantidad)" : ""}:'), Text(formatCurrency(subtotal * cantidad))]),
              if (taxEnabled && settings.activeVisibleTaxes.isNotEmpty) ...[
                const SizedBox(height: 4),
                ...settings.activeVisibleTaxes.map((tax) {
                  final rate = double.tryParse(tax['rate'].toString()) ?? 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('${tax['name']} (${rate.toStringAsFixed(rate.truncateToDouble() == rate ? 0 : 1)}%):', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                      Text(formatCurrency((subtotal * cantidad) * (rate / 100)), style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                    ]),
                  );
                }),
              ],
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(formatCurrency(total), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
              ]),
            ]),
          ),
        ]))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text('Registrar Venta'),
            onPressed: () async {
              if (clienteId == null || (servicioId == null && productoId == null)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ Selecciona cliente e item'), backgroundColor: Colors.orange));
                return;
              }

              final String itemNombre = type == 'servicio' 
                ? servicios.firstWhere((s) => s['id'].toString() == servicioId)['nombre']
                : productos.firstWhere((p) => p['id'].toString() == productoId)['nombre'];

              String? txId;
              if (metodoPago == 'transaccion') {
                final paymentResult = await PaymentService().processTransaction(context, total, {
                  'cliente_id': clienteId,
                  'item_nombre': itemNombre,
                });
                if (!paymentResult.success) {
                  if (paymentResult.status != 'cancelled') {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error en el pago: ${paymentResult.message}'), backgroundColor: Colors.red));
                  }
                  return;
                }
                txId = paymentResult.transactionId;
              }

              try {
                final saleResult = await api.createVenta({
                  'cliente_id': clienteId, 
                  'total': total,
                  'subtotal': subtotal * cantidad,
                  'iva_porcentaje': settings.totalActiveTaxRate,
                  'notas': notaCtrl.text,
                  'metodo_pago': metodoPago,
                  'transaction_id': txId,
                  'cita_id': prefilledCitaId,
                  'detalles': [{
                    'servicio_id': type == 'servicio' ? servicioId : null,
                    'producto_id': type == 'producto' ? productoId : null,
                    'descripcion': itemNombre,
                    'cantidad': cantidad,
                    'precio_unitario': subtotal
                  }],
                });
                
                if (!mounted) return;
                Navigator.pop(ctx, true);
                
                if (saleResult != null) {
                  _load();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Venta registrada: ${saleResult['numero_factura']} (Método: $metodoPago)'), backgroundColor: Colors.green));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Error al registrar la venta'), backgroundColor: Colors.red));
                }
              } on OfflineException catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]),
                  backgroundColor: Colors.red[700],
                ));
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red));
              }
            },
          ),
        ],
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final api = ApiService();
    final isClient = api.userRole?.contains('Cliente') ?? false;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.withOpacity(0.1), Colors.transparent])),
          child: Column(children: [
            Row(children: [
              const Icon(Icons.point_of_sale, color: Colors.green, size: 28), const SizedBox(width: 12),
              Expanded(child: Text('Ventas & Facturación', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary))),
              if (!isClient && !isMobile) ...[
                FilledButton.icon(onPressed: _showCrearVenta, icon: const Icon(Icons.add), label: const Text('Nueva Venta')),
                const SizedBox(width: 8),
              ],
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            ]),
            if (isMobile && !isClient) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(onPressed: _showCrearVenta, icon: const Icon(Icons.add), label: const Text('Nueva Venta'))
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(hintText: 'Buscar venta por factura o cliente...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
            ),
          ]),
        ),
        Expanded(
          child: _loading ? const Center(child: CircularProgressIndicator())
            : _filtradas.isEmpty ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.receipt_long, size: 64, color: Colors.grey[300]), const SizedBox(height: 12), Text('No se encontraron ventas', style: TextStyle(color: Colors.grey[500]))]))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filtradas.length,
                itemBuilder: (_, i) {
                  final v = _filtradas[i];
                  final estadoColor = v['estado'] == 'pagada' ? Colors.green : v['estado'] == 'pendiente' ? Colors.orange : Colors.red;
                  final double ivaPct = double.tryParse(v['iva_porcentaje']?.toString() ?? '0') ?? 0.0;
                  final String taxLabel = ivaPct > 0 ? 'Imp: ${formatCurrency(v['iva_monto'])} (${ivaPct.toStringAsFixed(ivaPct.truncateToDouble() == ivaPct ? 0 : 1)}%)' : 'Sin impuestos';
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoicePreviewScreen(venta: v),
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(backgroundColor: estadoColor.withOpacity(0.15), child: Icon(Icons.receipt, color: estadoColor)),
                      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(v['numero_factura'] ?? 'S/N', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(formatCurrency(v['total']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primary)),
                      ]),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: 4),
                        Text('Cliente: ${v['cliente_nombre'] ?? '#${v['cliente_id']}'}'),
                        Row(children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: estadoColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(v['estado'].toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: estadoColor))),
                          const SizedBox(width: 8),
                          Text(_getMetodoIcon(v['metodo_pago']), style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(taxLabel, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        ]),
                        Text(v['fecha_venta'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      ]),
                    ),
                  );
                },
              ),
        ),
      ]),
    );
  }

  String _getMetodoIcon(String? metodo) => switch (metodo) { 'tarjeta' => '💳 Tarjeta', 'transferencia' => '🏦 Transferencia', 'transaccion' => '📱 Transacción', _ => '💵 Efectivo', };
}
