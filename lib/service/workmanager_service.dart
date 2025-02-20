import 'dart:math';

import 'package:resto_dicodingsubs/service/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';

import '../api/api_service.dart';
import '../static/workmanager.dart';
import 'http_service.dart';

// todo-01-service-04: add initialization and we add it later
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final httpService = HttpService();
    final apiService = ApiService();
    final notificationService = LocalNotificationService(httpService);

    try {
      // Fetch the list of restaurants
      final restaurantsResponse = await apiService.getRestaurants();
      final restaurants = restaurantsResponse.restaurants;

      if (restaurants != null && restaurants.isNotEmpty) {
        // Select a random restaurant
        final random = Random();
        final randomRestaurant =
            restaurants[random.nextInt(restaurants.length)];

        // Show a notification with the random restaurant details
        await notificationService.showBigPictureNotification(
            id: randomRestaurant.id.hashCode,
            // Use restaurant ID as notification ID
            title: "Check Out This Restaurant!",
            body: "How about trying ${randomRestaurant.name}?",
            payload: randomRestaurant.id,
            // Optional payload
            image: randomRestaurant.pictureId);

        print("Notification shown for restaurant: ${randomRestaurant.name}");
      } else {
        print("No restaurants found.");
      }
    } on Exception catch (e) {
      print("Error in callbackDispatcher: ${e.toString()}");
    }

    return Future.value(true);
  });
}

// todo-01-service-02: create a file and name it WorkmanagerService
class WorkmanagerService {
  // todo-01-service-03: add constructor
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager])
      : _workmanager = workmanager ??= Workmanager();

  // todo-01-service-04: add initialization
  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  // todo-01-service-05: add a runOneOffTask function
  Future<void> runOneOffTask() async {
    await _workmanager.registerOneOffTask(
      MyWorkmanager.oneOff.uniqueName,
      MyWorkmanager.oneOff.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "data": "This is a valid payload from oneoff task workmanager",
      },
    );
  }

  // todo-01-service-06: add a runPeriodicTask function
  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(minutes: 16),
      initialDelay: Duration.zero,
      inputData: {
        "data": "This is a valid payload from periodic task workmanager",
      },
    );
  }

  // todo-01-service-07: add a cancelAllTask function
  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
