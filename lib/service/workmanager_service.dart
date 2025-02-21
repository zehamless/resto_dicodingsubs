import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:resto_dicodingsubs/service/local_notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../api/api_service.dart';
import '../static/workmanager.dart';
import 'http_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final notificationService = LocalNotificationService(HttpService());
    final apiService = ApiService();

    try {
      final restaurants = (await apiService.getRestaurants()).restaurants;
      if (restaurants != null && restaurants.isNotEmpty) {
        final randomRestaurant =
            restaurants[Random().nextInt(restaurants.length)];
        await notificationService.showBigPictureNotification(
          id: randomRestaurant.id.hashCode,
          title: "Check Out This Restaurant!",
          body: "How about trying ${randomRestaurant.name}?",
          payload: randomRestaurant.id,
          image: randomRestaurant.pictureId,
        );
      } else {
        developer.log('No restaurants found');
      }
    } catch (e) {
      developer.log('Error: $e');
    }

    return Future.value(true);
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager])
      : _workmanager = workmanager ?? Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<void> runPeriodicTask() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime next11am =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 11, 0, 0);
    if (now.isAfter(next11am)) {
      next11am = next11am.add(const Duration(days: 1));
    }
    final Duration initialDelay = next11am.difference(now);

    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(days: 1),
      initialDelay: initialDelay,
      inputData: {
        "data": "This is a valid payload from periodic task workmanager"
      },
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
