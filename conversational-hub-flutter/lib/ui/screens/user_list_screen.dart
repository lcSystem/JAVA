import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/presence_provider.dart';
import '../../core/services/preferences_provider.dart';
import '../../features/chat/presentation/providers/chat_provider.dart';

class UserListScreen extends StatelessWidget {
  UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenceProvider = Provider.of<PresenceProvider>(context);
    final prefs = Provider.of<PreferencesProvider>(context);

    final bgColor = prefs.isDarkMode ? const Color(0xFF13131A) : Colors.grey[50];
    final cardColor = prefs.isDarkMode ? const Color(0xFF1C1C26) : Colors.white;
    final textColor = prefs.isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Contactos', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: cardColor,
        elevation: 0.5,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: presenceProvider.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: prefs.primaryColor));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 48, color: textColor.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Text('No hay usuarios disponibles', style: TextStyle(color: textColor.withOpacity(0.5))),
                ],
              ),
            );
          }

          final users = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final bool isOnline = user['online'] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: prefs.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[200]!),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: (isOnline ? prefs.primaryColor : Colors.grey).withOpacity(0.1),
                        child: Text(
                          user['username'][0].toUpperCase(),
                          style: TextStyle(color: isOnline ? prefs.primaryColor : Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: cardColor, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    user['username'],
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    isOnline ? 'En línea' : 'Desconectado',
                    style: TextStyle(color: isOnline ? Colors.green : textColor.withOpacity(0.4), fontSize: 13),
                  ),
                  trailing: Icon(Icons.chevron_right, color: textColor.withOpacity(0.2)),
                  onTap: () async {
                    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                    final channel = await chatProvider.startPrivateChat(
                      user['userId'], 
                      user['username']
                    );
                    if (channel != null && context.mounted) {
                      Navigator.pop(context); // Volver a ChatPage ya con el canal seleccionado
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
