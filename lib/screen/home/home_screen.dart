import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/home/restaurant_list_provider.dart';
import 'package:resto_dicodingsubs/screen/home/restaurant_card_widget.dart';
import 'package:resto_dicodingsubs/utils/theme_changer.dart';

import '../../api/api_service.dart';
import '../../model/received-notification.dart';
import '../../provider/notification/local_notification_provider.dart';
import '../../provider/notification/payload_provider.dart';
import '../../service/local_notification_service.dart';
import '../../service/workmanager_service.dart';
import '../../static/navigation_route.dart';
import '../../static/restaurant_list_result_state.dart';
import '../../utils/notification_icon_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      context.read<PayloadProvider>().payload = payload;
      Navigator.pushNamed(context, NavigationRoute.detailRoute.name,
          arguments: payload);
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      final payload = receivedNotification.payload;
      context.read<PayloadProvider>().payload = payload;
      Navigator.pushNamed(context, NavigationRoute.detailRoute.name,
          arguments: receivedNotification.payload);
    });
  }

  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<RestoListProvider>().fetchRestoList();
    });
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.restaurant),
            SizedBox(width: 8),
            Text('RestoDicodingSubs'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, NavigationRoute.searchRoute.name);
            },
          ),
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                // enabled: false,
                child: const ThemeChanger(label: true),
              ),
              PopupMenuItem(child: const NotificationIcon(label: true)),
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Check Pending Notification Requests'),
                  onTap: () {
                    _checkPendingNotificationRequests();
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Run Background One Off Task'),
                  onTap: () {
                    _runBackgroundOneOffTask();
                  },
                ),
              ),
            ];
          }),
        ],
      ),
      body: Consumer<RestoListProvider>(builder: (context, value, child) {
        return switch (value.resultState) {
          RestoListResultLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          RestoListResultLoaded(data: var restoList) => ListView.builder(
              itemCount: restoList.length,
              itemBuilder: (context, index) {
                final resto = restoList[index];
                return RestoCard(
                  restaurant: resto,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      NavigationRoute.detailRoute.name,
                      arguments: resto.id,
                    );
                  },
                  imageUrl: ApiService()
                      .getImageUrl(resto.pictureId, ImageSize.medium),
                );
              },
            ),
          RestoListResultError(error: var message) => Center(
              child: Text(message),
            ),
          _ => const SizedBox(),
        };
      }),
    );
  }

  void _runBackgroundOneOffTask() async {
    // todo-02-action-01: run the runOneOffTask function
    context.read<WorkmanagerService>().runOneOffTask();
  }

  Future<void> _checkPendingNotificationRequests() async {
    // todo-03-action-02: check a pending notification
    final localNotificationProvider = context.read<LocalNotificationProvider>();
    await localNotificationProvider.checkPendingNotificationRequests(context);

    // todo-03-action-03: show a dialog to show a pending notification
    if (!mounted) {
      return;
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // todo-03-action-04: show alert dialog with empty listview builder
        final pendingData = context.select(
            (LocalNotificationProvider provider) =>
                provider.pendingNotificationRequests);
        return AlertDialog(
          title: Text(
            '${pendingData.length} pending notification requests',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: pendingData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // todo-03-action-05: iterate a listtile
                final item = pendingData[index];
                return ListTile(
                  title: Text(
                    item.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.body ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  contentPadding: EdgeInsets.zero,
                  trailing: IconButton(
                    onPressed: () {
                      localNotificationProvider
                        ..cancelNotification(item.id)
                        ..checkPendingNotificationRequests(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
