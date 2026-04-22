import 'dart:async';
import 'api_service.dart';

class InAppNotificationService {
  static final InAppNotificationService _instance = InAppNotificationService._internal();
  factory InAppNotificationService() => _instance;
  InAppNotificationService._internal();

  final _api = ApiService();
  final _newNotificationController = StreamController<dynamic>.broadcast();
  Timer? _timer;
  int? _lastNotifedId;

  Stream<dynamic> get notificationsStream => _newNotificationController.stream;

  void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _checkNewNotifications());
  }

  void stopPolling() {
    _timer?.cancel();
  }

  Future<void> _checkNewNotifications() async {
    if (_api.token == null) return;

    try {
      final notifs = await _api.getNotifications(unreadOnly: true);
      if (notifs.isNotEmpty) {
        final latest = notifs.first;
        final latestId = int.tryParse(latest['id'].toString());

        if (latestId != null && (_lastNotifedId == null || latestId > _lastNotifedId!)) {
          _lastNotifedId = latestId;
          _newNotificationController.add(latest);
        }
      }
    } catch (e) {
      print("Error polling notifications: $e");
    }
  }

  void dispose() {
    _timer?.cancel();
    _newNotificationController.close();
  }
}
