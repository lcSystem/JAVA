import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/formatters.dart';
import 'pqrs_form_screen.dart';
import 'pqrs_detail_screen.dart';

class PqrsListScreen extends StatefulWidget {
  const PqrsListScreen({super.key});

  @override
  State<PqrsListScreen> createState() => _PqrsListScreenState();
}

class _PqrsListScreenState extends State<PqrsListScreen> {
  final ApiService _api = ApiService();
  List<dynamic> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    final data = await _api.getPqrs();
    if (mounted) {
      setState(() {
        _reports = data;
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'abierto': return Colors.blue;
      case 'en_progreso': return Colors.orange;
      case 'resuelto': return Colors.green;
      case 'cerrado': return Colors.grey;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isClient = _api.userRole?.contains('Cliente') ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PQRS - Reportar Inconvenientes'),
        actions: [
          IconButton(onPressed: _loadReports, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadReports,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _reports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.support_agent, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text('No hay ningún reporte registrado', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () async {
                            final success = await Navigator.push(context, MaterialPageRoute(builder: (_) => const PqrsFormScreen()));
                            if (success == true) _loadReports();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Crear Primer Reporte'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _reports.length,
                    itemBuilder: (context, index) {
                      final item = _reports[index];
                      final statusColor = _getStatusColor(item['estado']);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => PqrsDetailScreen(pqrsId: item['id'])));
                            _loadReports();
                          },
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: statusColor.withOpacity(0.1),
                            child: Icon(Icons.description, color: statusColor),
                          ),
                          title: Text(item['asunto'] ?? 'Sin asunto', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(item['descripcion'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      (item['estado'] ?? 'abierto').toUpperCase(),
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['tipo']?.toString().toUpperCase() ?? '',
                                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Por: ${item['autor_nombre'] ?? 'N/A'}',
                                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final success = await Navigator.push(context, MaterialPageRoute(builder: (_) => const PqrsFormScreen()));
          if (success == true) _loadReports();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Reporte'),
      ),
    );
  }
}
