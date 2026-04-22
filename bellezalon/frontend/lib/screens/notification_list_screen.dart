import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/settings_provider.dart';
import '../utils/formatters.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final ApiService _api = ApiService();
  final SettingsProvider _settings = SettingsProvider(); // Will be used from context
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _notifications = [];
  List<dynamic> _users = [];
  bool _isLoading = true;
  int? _selectedUserId;
  late bool _isAdmin;

  @override
  void initState() {
    super.initState();
    _isAdmin = _api.userRole?.toLowerCase() == 'administrador';
    if (_isAdmin) {
      _loadUsers();
    }
    _loadNotifications();
  }

  Future<void> _loadUsers() async {
    try {
      final employees = await _api.getEmpleadosOnly();
      final clients = await _api.getClientesOnly();
      if (mounted) {
        setState(() {
          _users = [...employees, ...clients];
        });
      }
    } catch (e) {
      debugPrint("Error loading users for filter: $e");
    }
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final data = await _api.getNotifications(
        userId: _selectedUserId,
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
      );
      if (mounted) {
        setState(() {
          _notifications = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _markRead(int id) async {
    final success = await _api.markNotificationRead(id);
    if (success) {
      _loadNotifications();
    }
  }

  Future<void> _markAllRead() async {
    final success = await _api.markAllNotificationsRead(_api.userId!);
    if (success) {
      _loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: _loadNotifications, icon: const Icon(Icons.refresh)),
          if (!_isAdmin)
            IconButton(
              onPressed: _markAllRead, 
              icon: const Icon(Icons.done_all),
              tooltip: 'Marcar todas como leídas',
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(primary),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final n = _notifications[index];
                          return _buildNotificationCard(n, primary);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(Color primary) {
    if (!_isAdmin) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (_) => _loadNotifications(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: _selectedUserId,
                      hint: const Text('Usuario', style: TextStyle(fontSize: 12)),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Todos', style: TextStyle(fontSize: 12))),
                        ..._users.map((u) => DropdownMenuItem(
                          value: int.tryParse(u['id'].toString()),
                          child: Text(u['full_name'] ?? u['username'], style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                        )),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedUserId = val);
                        _loadNotifications();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No hay notificaciones para mostrar', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(dynamic n, Color primary) {
    final isRead = n['is_read'] == 1;
    final type = n['type'] ?? 'info';
    final date = DateTime.parse(n['created_at']);
    final timeStr = Consumer<SettingsProvider>(
      builder: (context, settings, _) => Text(
        formatDateTime(date, settings.timeFormat),
        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
      ),
    );

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: isRead ? Colors.white : primary.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isRead ? Colors.grey[200]! : primary.withOpacity(0.2)),
      ),
      child: ListTile(
        onTap: () {
          if (!isRead) _markRead(n['id']);
          _handleInteraction(n);
        },
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(type).withOpacity(0.1),
          child: Icon(_getTypeIcon(type), color: _getTypeColor(type), size: 20),
        ),
        title: Text(
          n['title'] ?? 'Notificación',
          style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(n['message'] ?? '', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                timeStr,
                if (_isAdmin && (n['full_name'] != null || n['username'] != null))
                  Text(
                    'Para: ${n['full_name'] ?? n['username']}',
                    style: TextStyle(fontSize: 10, color: primary, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
        trailing: !isRead ? Icon(Icons.circle, size: 10, color: primary) : null,
      ),
    );
  }

  void _handleInteraction(dynamic n) {
    if (n['context_type'] == 'chat' && n['context_id'] != null) {
      final citaId = int.tryParse(n['context_id'].toString());
      if (citaId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              citaId: citaId,
              otherPartyName: n['title'] ?? 'Chat',
              isChatEnabled: true, // Assuming active for notifications
            ),
          ),
        );
      }
    } else if (n['context_type'] == 'cita') {
      // Navigate to Agenda or similar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abriendo detalles de la cita...')),
      );
      // Depending on app structure, we might navigate to CalendarScreen with a specific day
    } else if (n['type'] == 'chat') {
      // Fallback for old notifications
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Navega al chat desde la sección correspondiente.')),
      );
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'chat': return Icons.chat;
      case 'cita': return Icons.calendar_today;
      case 'warning': return Icons.warning;
      case 'success': return Icons.check_circle;
      default: return Icons.info;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'chat': return Colors.teal;
      case 'cita': return Colors.blue;
      case 'warning': return Colors.orange;
      case 'success': return Colors.green;
      default: return Colors.blueGrey;
    }
  }
}
