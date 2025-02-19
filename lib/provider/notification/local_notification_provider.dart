import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService) {
    loadDailyNotificationPreference();
  }

  int _notificationId = 0;
  bool? _permission = false;

  bool? get permission => _permission;

  // List of pending notifications
  List<PendingNotificationRequest> pendingNotificationRequests = [];

  // Daily notification toggle state
  bool _isDailyNotificationEnabled = false;

  bool get isDailyNotificationEnabled => _isDailyNotificationEnabled;

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  void showNotification() {
    _notificationId += 1;
    flutterNotificationService.showNotification(
      id: _notificationId,
      title: "New Notification",
      body: "This is a new notification with id $_notificationId",
      payload: "Payload for notification id $_notificationId",
    );
  }

  void showBigPictureNotification() {
    _notificationId += 1;
    flutterNotificationService.showBigPictureNotification(
      id: _notificationId,
      title: "New Big Picture Notification",
      body: "This is a new big picture notification with id $_notificationId",
      payload: "Payload for big picture notification id $_notificationId",
    );
  }

  // Use a fixed ID for the daily notification so it can be toggled easily.
  static const int dailyNotificationId = 999;

  void scheduleDaily11AMNotification() {
    flutterNotificationService.scheduleDaily11AMNotification(
      id: dailyNotificationId,
    );
  }

  /// Toggles the daily notification.
  Future<void> toggleDailyNotification() async {
    final prefs = await SharedPreferences.getInstance();
    _isDailyNotificationEnabled = !_isDailyNotificationEnabled;
    await prefs.setBool(
        'dailyNotificationEnabled', _isDailyNotificationEnabled);
    notifyListeners();

    if (_isDailyNotificationEnabled) {
      scheduleDaily11AMNotification();
    } else {
      await flutterNotificationService.cancelNotification(dailyNotificationId);
    }
  }

  /// Loads the daily notification state from SharedPreferences.
  Future<void> loadDailyNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDailyNotificationEnabled =
        prefs.getBool('dailyNotificationEnabled') ?? false;
    notifyListeners();
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests =
        await flutterNotificationService.pendingNotificationRequests();
    notifyListeners();
  }

  Future<void> cancelNotification(int id) async {
    await flutterNotificationService.cancelNotification(id);
  }
}
