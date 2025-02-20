import 'dart:developer' as developer;
import 'dart:math';

import 'package:resto_dicodingsubs/service/local_notification_service.dart';
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
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: false);
  }

  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(minutes: 16),
      initialDelay: Duration.zero,
      inputData: {
        "data": "This is a valid payload from periodic task workmanager"
      },
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
