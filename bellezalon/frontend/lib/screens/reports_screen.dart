import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/formatters.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<dynamic> _ingresos = [];
  List<dynamic> _serviciosTop = [];
  List<dynamic> _empleados = [];
  List<dynamic> _clientesTop = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final api = ApiService();
    final results = await Future.wait([
      api.getReporteIngresos(), 
      api.getReporteServiciosTop(), 
      api.getReporteEmpleados(),
      api.getReporteClientesTop()
    ]);
    setState(() { 
      _ingresos = results[0]; 
      _serviciosTop = results[1]; 
      _empleados = results[2]; 
      _clientesTop = results[3];
      _loading = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      body: _loading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purple.withOpacity(0.1), Colors.transparent])),
            child: Row(children: [
              const Icon(Icons.analytics, color: Colors.purple, size: 28), const SizedBox(width: 12),
              Text('Reportes de Negocio', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary)),
              const Spacer(),
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            ]),
          ),
          // KPI Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _buildKPICard('Ventas Hoy', _ingresos.isNotEmpty ? formatCurrency(_ingresos.first['ingresos']) : formatCurrency(0), Icons.trending_up, Colors.green),
              const SizedBox(width: 12),
              _buildKPICard('Total Ventas', _ingresos.fold<int>(0, (sum, e) => sum + (int.tryParse(e['total_ventas']?.toString() ?? '0') ?? 0)).toString(), Icons.shopping_cart, Colors.blue),
              const SizedBox(width: 12),
              _buildKPICard('IVA Recaudado', _ingresos.isNotEmpty ? formatCurrency(_ingresos.first['total_iva']) : formatCurrency(0), Icons.account_balance, Colors.orange),
            ]),
          ),
          const SizedBox(height: 24),
          // Revenue Bar Chart (text-based)
          _buildSection('📈 Ingresos por Período', _ingresos.isEmpty
            ? const Center(child: Text('Sin datos de ingresos aún'))
            : Column(children: _ingresos.take(7).map((i) {
                final ingresos = double.tryParse(i['ingresos']?.toString() ?? '0') ?? 0;
                final maxVal = _ingresos.map((e) => double.tryParse(e['ingresos']?.toString() ?? '0') ?? 0).reduce((a, b) => a > b ? a : b);
                final pct = maxVal > 0 ? (ingresos / maxVal) : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Row(children: [
                    SizedBox(width: 90, child: Text(i['periodo'] ?? '', style: const TextStyle(fontSize: 12))),
                    Expanded(child: Stack(children: [
                      Container(height: 24, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(6))),
                      FractionallySizedBox(widthFactor: pct, child: Container(height: 24, decoration: BoxDecoration(color: Colors.green.withOpacity(0.7), borderRadius: BorderRadius.circular(6)))),
                    ])),
                    const SizedBox(width: 8),
                    SizedBox(width: 80, child: Text(formatCurrency(ingresos), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.right)),
                  ]),
                );
              }).toList()),
          ),
          const SizedBox(height: 24),
          // Top Services
          _buildSection('🏆 Servicios Más Vendidos', _serviciosTop.isEmpty
            ? const Center(child: Text('Sin datos de servicios'))
            : Column(children: _serviciosTop.map((s) => ListTile(
                dense: true,
                leading: CircleAvatar(radius: 16, backgroundColor: primary.withOpacity(0.15), child: Text('${s['total_vendido']}', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 12))),
                title: Text(s['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Text(formatCurrency(s['ingresos']), style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
              )).toList()),
          ),
          const SizedBox(height: 24),
          // Employee Productivity
          _buildSection('👤 Productividad Empleados', _empleados.isEmpty
            ? const Center(child: Text('Sin datos de empleados'))
            : Column(children: _empleados.map((e) => ListTile(
                dense: true,
                leading: CircleAvatar(radius: 16, backgroundColor: Colors.blue.withOpacity(0.15), child: const Icon(Icons.person, size: 16, color: Colors.blue)),
                title: Text(e['nombre_completo'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('Citas: ${e['total_citas']} • Completadas: ${e['completadas']}'),
                trailing: Text(formatCurrency(e['ingresos_generados']), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              )).toList()),
          ),
          const SizedBox(height: 24),
          // Top Clients
          _buildSection('🌟 Mejores Clientes (Tendencia)', _clientesTop.isEmpty
            ? const Center(child: Text('Sin datos de clientes aún'))
            : Column(children: _clientesTop.take(10).map((c) {
                final gastado = double.tryParse(c['total_gastado']?.toString() ?? '0') ?? 0;
                final citas = int.tryParse(c['citas_completadas']?.toString() ?? '0') ?? 0;
                final maxVal = _clientesTop.map((e) => double.tryParse(e['total_gastado']?.toString() ?? '0') ?? 0).reduce((a, b) => a > b ? a : b);
                final pct = maxVal > 0 ? (gastado / maxVal) : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(children: [
                    SizedBox(width: 120, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c['nombre_completo'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('$citas citas completadas', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ])),
                    const SizedBox(width: 8),
                    Expanded(child: Stack(children: [
                      Container(height: 16, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4))),
                      FractionallySizedBox(widthFactor: pct, child: Container(height: 16, decoration: BoxDecoration(color: Colors.purple.withOpacity(0.6), borderRadius: BorderRadius.circular(4)))),
                    ])),
                    const SizedBox(width: 12),
                    SizedBox(width: 80, child: Text(formatCurrency(gastado), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.right)),
                  ]),
                );
              }).toList()),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Expanded(child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
            const Spacer(),
          ]),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ]),
      ),
    ));
  }

  Widget _buildSection(String title, Widget content) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      const SizedBox(height: 8),
      content,
    ]);
  }
}
