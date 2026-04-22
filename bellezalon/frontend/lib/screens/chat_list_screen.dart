import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/settings_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _isLoading = true;
  List<dynamic> _chats = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);
    final chats = await ApiService().getMyChats();
    setState(() {
      _chats = chats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final primary = settings.primaryColor;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chats.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: _chats.length,
                  separatorBuilder: (_, __) => const Divider(indent: 80, height: 1),
                  itemBuilder: (context, index) {
                    final chat = _chats[index];
                    final isPendiente = chat['estado'] == 'pendiente';
                    
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primary.withOpacity(0.1),
                        child: Icon(Icons.person, color: primary),
                      ),
                      title: Text(
                        ApiService().userRole == 'Cliente' ? chat['empleado_nombre'] : chat['cliente_nombre'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cita #${chat['cita_id']} - ${chat['fecha_cita']} ${chat['hora_cita']}'),
                          if (chat['last_message'] != null)
                            Text(
                              chat['last_message'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPendiente ? Colors.green[50] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          chat['estado'].toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isPendiente ? Colors.green[700] : Colors.grey[600],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              citaId: chat['cita_id'],
                              otherPartyName: ApiService().userRole == 'Cliente' ? chat['empleado_nombre'] : chat['cliente_nombre'],
                              isChatEnabled: isPendiente,
                            ),
                          ),
                        ).then((_) => _loadChats());
                      },
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No tienes chats activos',
            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Los chats se habilitan cuando creas una cita.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
