import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/formatters.dart';
import '../services/payments/payment_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _history = [];
  bool _isLoading = true;
  String _selectedStatus = 'todas';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final data = await _api.getHistory(
        status: _selectedStatus == 'todas' ? null : _selectedStatus,
        search: _searchController.text,
      );
      if (mounted) {
        setState(() {
          _history = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el historial: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completada': return Colors.green;
      case 'pendiente': return Colors.orange;
      case 'confirmada': return Colors.blue;
      case 'cancelada': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completada': return 'Completado';
      case 'pendiente': return 'Pendiente';
      case 'confirmada': return 'Confirmado';
      case 'cancelada': return 'Cancelado';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isClient = _api.userRole?.contains('Cliente') ?? false;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: isMobile ? Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar cliente o servicio...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => _loadHistory(),
                ),
                if (!isClient) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedStatus,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'todas', child: Text('Todos')),
                          DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                          DropdownMenuItem(value: 'confirmada', child: Text('Confirmado')),
                          DropdownMenuItem(value: 'completada', child: Text('Completado')),
                          DropdownMenuItem(value: 'cancelada', child: Text('Cancelado')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedStatus = val);
                            _loadHistory();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ) : Row(
              children: [
                Expanded(
                  flex: isClient ? 1 : 2,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar cliente o servicio...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _loadHistory(),
                  ),
                ),
                if (!isClient) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'todas', child: Text('Todos')),
                            DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                            DropdownMenuItem(value: 'confirmada', child: Text('Confirmado')),
                            DropdownMenuItem(value: 'completada', child: Text('Completado')),
                            DropdownMenuItem(value: 'cancelada', child: Text('Cancelado')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedStatus = val);
                              _loadHistory();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_outlined, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty || _selectedStatus != 'todas'
                                  ? 'No se encontraron resultados'
                                  : 'No hay servicios registrados aún',
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          final dateStr = item['fecha_cita'] ?? '';
                          final timeStr = item['hora_cita'] ?? '';
                          final price = double.tryParse(item['servicio_precio']?.toString() ?? '0') ?? 0.0;
                          final totalCobrado = double.tryParse(item['total_cobrado']?.toString() ?? '0') ?? 0.0;
                          final displayPrice = totalCobrado > 0 ? totalCobrado : price;
                          
                          final status = item['estado'] ?? 'completada';
                          final statusColor = _getStatusColor(status);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['servicio_nombre'] ?? 'Servicio',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Fecha: $dateStr a las $timeStr',
                                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          _getStatusText(status),
                                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    children: [
                                      if (!isClient) ...[
                                        Icon(Icons.person_outline, size: 18, color: primary),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Cliente: ${item['cliente_nombre'] ?? 'N/A'}',
                                            style: const TextStyle(fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                      ],
                                      Icon(Icons.badge_outlined, size: 18, color: primary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Atendido por: ${item['empleado_nombre'] ?? 'N/A'}',
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.timer_outlined, size: 18, color: primary),
                                          const SizedBox(width: 8),
                                          Text('${item['duracion_minutos'] ?? "30"} min', style: const TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            formatCurrency(displayPrice),
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary),
                                          ),
                                          if (totalCobrado > 0)
                                            const Text('Cobrado (Inc. IVA)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (item['payment_status'] == 'paid') ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.withOpacity(0.1))),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check_circle, color: Colors.blue, size: 16),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text('Pago online confirmado (${item['transaction_id'] ?? 'S/N'})', style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold))),
                                          if (status == 'cancelada')
                                            TextButton.icon(
                                              onPressed: () async {
                                                final confirm = await showDialog<bool>(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: const Text('Confirmar Reembolso'),
                                                    content: Text('¿Deseas procesar el reembolso de ${formatCurrency(displayPrice)} para el cliente?'),
                                                    actions: [
                                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
                                                      FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sí, Reembolsar')),
                                                    ],
                                                  ),
                                                );
                                                if (confirm == true) {
                                                  if (mounted) {
                                                    final res = await PaymentService().refund(context, item['transaction_id'], displayPrice);
                                                    if (res.success) {
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Reembolso procesado correctamente (Simulado)'), backgroundColor: Colors.green));
                                                      _loadHistory();
                                                    }
                                                  }
                                                }
                                              },
                                              icon: const Icon(Icons.undo, size: 16),
                                              label: const Text('Reembolsar', style: TextStyle(fontSize: 12)),
                                              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
