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

  bool? _permission = false;

  bool? get permission => _permission;

  List<PendingNotificationRequest> pendingNotificationRequests = [];
  bool _isDailyNotificationEnabled = false;

  bool get isDailyNotificationEnabled => _isDailyNotificationEnabled;

  Future<void> requestPermissions() async {
    _permission = await _notificationService.requestPermissions();
    notifyListeners();
  }

  Future<void> toggleDailyNotification() async {
    _isDailyNotificationEnabled = !_isDailyNotificationEnabled;
    await _sharedPreferences.setBool(
        'dailyNotificationEnabled', _isDailyNotificationEnabled);
    notifyListeners();

    if (_isDailyNotificationEnabled) {
      _workmanagerService.runPeriodicTask();
    } else {
      await _workmanagerService.cancelAllTask();
    }
  }

  Future<void> loadDailyNotificationPreference() async {
    _isDailyNotificationEnabled =
        _sharedPreferences.getBool('dailyNotificationEnabled') ?? false;
    notifyListeners();
  }

}
