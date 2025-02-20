import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resto_dicodingsubs/service/workmanager_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService _notificationService;
  final SharedPreferences _sharedPreferences;
  final WorkmanagerService _workmanagerService;

  LocalNotificationProvider(this._notificationService, this._sharedPreferences,
      this._workmanagerService) {
    loadDailyNotificationPreference();
  }

  int _notificationId = 0;
  bool? _permission = false;

  bool? get permission => _permission;

  List<PendingNotificationRequest> pendingNotificationRequests = [];
  bool _isDailyNotificationEnabled = false;

  bool get isDailyNotificationEnabled => _isDailyNotificationEnabled;

  Future<void> requestPermissions() async {
    _permission = await _notificationService.requestPermissions();
    notifyListeners();
  }

  void showNotification() {
    _notificationId++;
    _notificationService.showNotification(
      id: _notificationId,
      title: "New Notification",
      body: "This is a new notification with id $_notificationId",
      payload: "Payload for notification id $_notificationId",
    );
  }

  //
  // void showBigPictureNotification() {
  //   _notificationId++;
  //   _notificationService.showBigPictureNotification(
  //     id: _notificationId,
  //     title: "New Big Picture Notification",
  //     body: "This is a new big picture notification with id $_notificationId",
  //     payload: "Payload for big picture notification id $_notificationId",
  //   );
  // }

  static const int dailyNotificationId = 999;

  void scheduleDaily11AMNotification() {
    _notificationService.scheduleDaily11AMNotification(id: dailyNotificationId);
  }

  Future<void> toggleDailyNotification() async {
    _isDailyNotificationEnabled = !_isDailyNotificationEnabled;
    await _sharedPreferences.setBool(
        'dailyNotificationEnabled', _isDailyNotificationEnabled);
    notifyListeners();

    if (_isDailyNotificationEnabled) {
      scheduleDaily11AMNotification();
      _workmanagerService.runPeriodicTask();
    } else {
      await _notificationService.cancelNotification(dailyNotificationId);
      await _workmanagerService.cancelAllTask();
    }
  }

  Future<void> loadDailyNotificationPreference() async {
    _isDailyNotificationEnabled =
        _sharedPreferences.getBool('dailyNotificationEnabled') ?? false;
    notifyListeners();
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests =
        await _notificationService.pendingNotificationRequests();
    notifyListeners();
  }

  Future<void> cancelNotification(int id) async {
    await _notificationService.cancelNotification(id);
  }
}
