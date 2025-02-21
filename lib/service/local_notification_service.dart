import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resto_dicodingsubs/api/api_service.dart';
import 'package:resto_dicodingsubs/main.dart'; // Pastikan global navigatorKey diimpor
import 'package:resto_dicodingsubs/service/http_service.dart';
import 'package:resto_dicodingsubs/static/navigation_route.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  final HttpService httpService;

  LocalNotificationService(this.httpService);

  Future<void> init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) async {
        final payload = notificationResponse.payload;
        if (payload != null && payload.isNotEmpty) {
          navigatorKey.currentState?.pushNamed(
            NavigationRoute.detailRoute.name,
            arguments: payload,
          );
        }
      },
    );
  }

  Future<bool> _isAndroidPermissionGranted() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<bool> _requestAndroidNotificationsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false;
  }

  Future<bool> _requestExactAlarmsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestExactAlarmsPermission() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    final notificationEnabled = await _isAndroidPermissionGranted();
    final requestAlarmEnabled = await _requestExactAlarmsPermission();
    if (!notificationEnabled) {
      final requestNotificationsPermission =
          await _requestAndroidNotificationsPermission();
      return requestNotificationsPermission && requestAlarmEnabled;
    }
    return notificationEnabled && requestAlarmEnabled;
  }

  Future<void> showBigPictureNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required String image,
    String channelId = "2",
    String channelName = "Big Picture Notification",
  }) async {
    final String largeIconPath = await httpService.downloadAndSaveFile(
        ApiService().getImageUrl(image, ImageSize.small), id.toString());
    final String bigPicturePath = await httpService.downloadAndSaveFile(
        ApiService().getImageUrl(image, ImageSize.medium), id.toString());
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title.toString(),
      htmlFormatContentTitle: true,
      summaryText: body.toString(),
      htmlFormatSummaryText: true,
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: bigPictureStyleInformation,
    );
    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
