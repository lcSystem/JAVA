import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conversational_hub_flutter/features/chat/presentation/providers/chat_provider.dart';
import 'package:conversational_hub_flutter/features/chat/presentation/widgets/message_bubble.dart';

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
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2C2C3E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona un Sticker',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                          color: Colors.white.withOpacity(0.05),
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
    return Scaffold(
      backgroundColor: const Color(0xFF13131A), // Dark premium background
      body: Row(
        children: [
          // Sidebar - Channel List
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C26),
              border: Border(right: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Text(
                    'Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
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
                      color: Colors.orangeAccent.withOpacity(0.8),
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
                        return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
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
                              onTap: () => provider.selectChannel(channel),
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF2D55)])
                                      : null,
                                  color: isSelected ? null : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.tag, color: isSelected ? Colors.white : Colors.white54, size: 18),
                                    const SizedBox(width: 12),
                                    Text(
                                      channel.name,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.white70,
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
          ),
          
          // Main Chat Area
          Expanded(
            child: Column(
              children: [
                // Chat Header
                Consumer<ChatProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13131A),
                        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.tag, color: Colors.orangeAccent, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            provider.selectedChannel?.name ?? 'Selecciona un canal', 
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                // Messages List
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'), // Subtle texture
                        opacity: 0.05,
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                    child: Consumer<ChatProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading && provider.messages.isEmpty) {
                          return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
                        }
                        if (provider.messages.isEmpty && provider.selectedChannel != null) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 48, color: Colors.white.withOpacity(0.2)),
                                const SizedBox(height: 16),
                                Text('Sé el primero en enviar un mensaje', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(24.0),
                          itemCount: provider.messages.length,
                          itemBuilder: (context, index) {
                            // Determine user logic context for displaying sides
                            bool isMe = provider.messages[index].senderId.toLowerCase() == 'lsyst';
                            return MessageBubble(
                              message: provider.messages[index],
                              isMe: isMe,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                
                // Message Input
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, -4),
                        blurRadius: 16,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Sticker Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.orangeAccent),
                          onPressed: _showStickerPicker,
                          tooltip: 'Enviar Sticker',
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Text Field
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF13131A),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white),
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
                      
                      // Send Button
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF2D55)]),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF2D55),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ]
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.white),
                          onPressed: _handleSendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
