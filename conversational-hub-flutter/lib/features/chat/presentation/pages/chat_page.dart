import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conversational_hub_flutter/features/chat/presentation/providers/chat_provider.dart';
import 'package:conversational_hub_flutter/features/chat/presentation/widgets/message_bubble.dart';
import 'package:conversational_hub_flutter/ui/widgets/floating_chat_bubble.dart';
import 'package:conversational_hub_flutter/core/services/preferences_provider.dart';
import 'package:conversational_hub_flutter/ui/screens/user_list_screen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _stickers = ['🚀', '🔥', '🎉', '😎', '☕', '💡', '🤖', '🦄', '🐶', '🍕'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadChannels();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showStickerPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final prefs = Provider.of<PreferencesProvider>(context);
        final textColor = prefs.isDarkMode ? Colors.white : Colors.black87;
        
        return Container(
          decoration: BoxDecoration(
            color: prefs.isDarkMode ? const Color(0xFF2C2C3E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecciona un Sticker',
                style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _stickers.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _sendSticker(_stickers[index]);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: prefs.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _stickers[index],
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendSticker(String sticker) {
    context.read<ChatProvider>().sendMessage('[STICKER]:$sticker');
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    context.read<ChatProvider>().sendMessage(_messageController.text);
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context);
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 900;

    final bgColor = prefs.isDarkMode ? const Color(0xFF13131A) : Colors.grey[50];
    final sidebarColor = prefs.isDarkMode ? const Color(0xFF1C1C26) : Colors.white;
    final textColor = prefs.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = prefs.isDarkMode ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: isMobile
          ? AppBar(
              title: Text(prefs.appName, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              backgroundColor: sidebarColor,
              elevation: 0.5,
              iconTheme: IconThemeData(color: textColor),
              actions: [
                IconButton(
                  icon: Icon(Icons.people, color: subTextColor),
                  onPressed: () => Navigator.pushNamed(context, '/users'),
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: subTextColor),
                  onPressed: () => Navigator.pushNamed(context, '/config'),
                ),
              ],
            )
          : null,
      drawer: isMobile ? Drawer(child: _buildSidebar(context, prefs, true)) : null,
      body: Stack(
        children: [
          Row(
            children: [
              if (!isMobile) _buildSidebar(context, prefs, false),
              Expanded(
                child: Column(
                  children: [
                    if (!isMobile) _buildHeader(context, prefs),
                    Expanded(child: _buildMessagesList(context, prefs)),
                    _buildInputArea(context, prefs),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Consumer<PreferencesProvider>(
        builder: (context, prefs, child) {
          if (!prefs.isFloatingBubble) return const SizedBox.shrink();
          return FloatingChatBubble(
            isVisible: true,
            themeColor: prefs.primaryColor,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat expandido desde burbuja')),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, PreferencesProvider prefs, bool isDrawer) {
    final sidebarColor = prefs.isDarkMode ? const Color(0xFF1C1C26) : Colors.white;
    final textColor = prefs.isDarkMode ? Colors.white : Colors.black87;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: sidebarColor,
        border: Border(right: BorderSide(color: prefs.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isDrawer)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Text(
                prefs.appName,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Text(
              'CANALES',
              style: TextStyle(
                color: prefs.primaryColor.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.channels.isEmpty) {
                  return Center(child: CircularProgressIndicator(color: prefs.primaryColor));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.channels.length,
                  itemBuilder: (context, index) {
                    final channel = provider.channels[index];
                    final isSelected = provider.selectedChannel?.id == channel.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                        onTap: () {
                          provider.selectChannel(channel);
                          if (isDrawer) Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(colors: [prefs.primaryColor, prefs.accentColor])
                                : null,
                            color: isSelected ? null : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.tag, color: isSelected ? Colors.white : (prefs.isDarkMode ? Colors.white54 : Colors.black45), size: 18),
                              const SizedBox(width: 12),
                              Text(
                                channel.name,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : (prefs.isDarkMode ? Colors.white70 : Colors.black87),
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PreferencesProvider prefs) {
    final textColor = prefs.isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = prefs.isDarkMode ? Colors.white70 : Colors.black54;

    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: prefs.isDarkMode ? const Color(0xFF13131A) : Colors.white,
            border: Border(bottom: BorderSide(color: prefs.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[200]!)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: prefs.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.tag, color: prefs.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  provider.selectedChannel?.name ?? 'Selecciona un canal', 
                  style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)
                ),
              ),
              IconButton(
                icon: Icon(Icons.people, color: subTextColor),
                onPressed: () => Navigator.pushNamed(context, '/users'),
              ),
              IconButton(
                icon: Icon(Icons.settings, color: subTextColor),
                onPressed: () => Navigator.pushNamed(context, '/config'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessagesList(BuildContext context, PreferencesProvider prefs) {
    final textColor = prefs.isDarkMode ? Colors.white : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: prefs.isDarkMode ? Colors.transparent : Colors.grey[50],
        image: const DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'),
          opacity: 0.03,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.messages.isEmpty) {
            return Center(child: CircularProgressIndicator(color: prefs.primaryColor));
          }
          if (provider.messages.isEmpty && provider.selectedChannel != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 48, color: textColor.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Text('Sé el primero en enviar un mensaje', style: TextStyle(color: textColor.withOpacity(0.5))),
                ],
              ),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(24.0),
            itemCount: provider.messages.length,
            itemBuilder: (context, index) {
              bool isMe = provider.messages[index].senderId.toLowerCase() == 'lsyst';
              return MessageBubble(
                message: provider.messages[index],
                isMe: isMe,
                color: isMe ? prefs.primaryColor : (prefs.isDarkMode ? const Color(0xFF2C2C3E) : Colors.white),
                textColor: isMe ? Colors.white : textColor,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, PreferencesProvider prefs) {
    final inputBg = prefs.isDarkMode ? const Color(0xFF1C1C26) : Colors.white;
    final textFieldBg = prefs.isDarkMode ? const Color(0xFF13131A) : Colors.grey[100];
    final textColor = prefs.isDarkMode ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: inputBg,
        border: Border(top: BorderSide(color: prefs.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[200]!)),
        boxShadow: [
          if (prefs.isDarkMode)
            BoxShadow(color: Colors.black.withOpacity(0.2), offset: const Offset(0, -4), blurRadius: 16)
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.emoji_emotions_outlined, color: prefs.primaryColor),
            onPressed: _showStickerPicker,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: textFieldBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: prefs.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[300]!),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: textColor),
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _handleSendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [prefs.primaryColor, prefs.accentColor]),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: _handleSendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
