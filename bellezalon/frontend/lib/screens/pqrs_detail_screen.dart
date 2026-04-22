import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/formatters.dart';

class PqrsDetailScreen extends StatefulWidget {
  final int pqrsId;
  const PqrsDetailScreen({super.key, required this.pqrsId});

  @override
  State<PqrsDetailScreen> createState() => _PqrsDetailScreenState();
}

class _PqrsDetailScreenState extends State<PqrsDetailScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _msgCtrl = TextEditingController();
  dynamic _pqrs;
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() => _isLoading = true);
    final data = await _api.getPqrsById(widget.pqrsId);
    if (mounted) {
      setState(() {
        _pqrs = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _sendResponse() async {
    if (_msgCtrl.text.isEmpty) return;
    setState(() => _isSending = true);
    final success = await _api.addPqrsRespuesta(widget.pqrsId, _msgCtrl.text);
    if (mounted) {
      if (success) {
        _msgCtrl.clear();
        _loadDetail();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Error al enviar respuesta'), backgroundColor: Colors.red));
      }
      setState(() => _isSending = false);
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    final success = await _api.updatePqrsStatus(widget.pqrsId, newStatus);
    if (success) _loadDetail();
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
    final userRole = _api.userRole?.toLowerCase() ?? '';
    final isStaff = userRole.contains('admin') || userRole.contains('empleado') || userRole.contains('staff');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Reporte'),
        actions: [
          if (isStaff && _pqrs != null)
            PopupMenuButton<String>(
              onSelected: _updateStatus,
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'abierto', child: Text('Abrir')),
                const PopupMenuItem(value: 'en_progreso', child: Text('En Progreso')),
                const PopupMenuItem(value: 'resuelto', child: Text('Resuelto')),
                const PopupMenuItem(value: 'cerrado', child: Text('Cerrar')),
              ],
              icon: const Icon(Icons.edit_note),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pqrs == null
              ? const Center(child: Text('No se encontró el reporte'))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              color: primary.withOpacity(0.05),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(color: _getStatusColor(_pqrs['estado']).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                          child: Text((_pqrs['estado'] ?? 'abierto').toUpperCase(), style: TextStyle(color: _getStatusColor(_pqrs['estado']), fontWeight: FontWeight.bold, fontSize: 12)),
                                        ),
                                        Text(_pqrs['created_at'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(_pqrs['asunto'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(_pqrs['descripcion'] ?? '', style: const TextStyle(fontSize: 16)),
                                    const Divider(height: 32),
                                    Row(
                                      children: [
                                        const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text('Reportado por: ${_pqrs['autor_nombre']}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text('Respuestas y Seguimiento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            if (_pqrs['respuestas'].isEmpty)
                              const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: Text('No hay respuestas aún', style: TextStyle(color: Colors.grey))))
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _pqrs['respuestas'].length,
                                itemBuilder: (ctx, i) {
                                  final resp = _pqrs['respuestas'][i];
                                  final isMe = resp['user_id'] == _api.userId;
                                  final role = resp['role_id'].toString();
                                  final isSupport = role == '1' || role == '2';

                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSupport ? Colors.indigo.withOpacity(0.05) : isMe ? primary.withOpacity(0.1) : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(16),
                                        border: isSupport ? Border.all(color: Colors.indigo.withOpacity(0.2)) : null,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(resp['autor_nombre'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isSupport ? Colors.indigo : primary)),
                                              if (isSupport) ...[
                                                const SizedBox(width: 4),
                                                const Icon(Icons.verified, size: 14, color: Colors.indigo),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(resp['mensaje'], style: const TextStyle(fontSize: 15)),
                                          const SizedBox(height: 4),
                                          Text(resp['created_at'], style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (_pqrs['estado'] != 'cerrado')
                      SafeArea(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2))]),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _msgCtrl,
                                  decoration: InputDecoration(hintText: 'Escribe una respuesta...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                  maxLines: null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filled(
                                onPressed: _isSending ? null : _sendResponse,
                                icon: _isSending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}
