import '../../domain/entities/channel.dart';
import '../../domain/entities/message.dart';

abstract class ChatRepository {
  Future<List<Channel>> getChannels();
  Future<List<Message>> getMessages(String channelId);
  Future<void> sendMessage(String channelId, String content);
}
