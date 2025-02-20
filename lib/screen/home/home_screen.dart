import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/home/restaurant_list_provider.dart';
import 'package:resto_dicodingsubs/screen/home/restaurant_card_widget.dart';
import 'package:resto_dicodingsubs/utils/theme_changer.dart';

import '../../api/api_service.dart';
import '../../provider/notification/payload_provider.dart';
import '../../service/local_notification_service.dart';
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
      // ignore: use_build_context_synchronously
      context.read<PayloadProvider>().payload = payload;
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, NavigationRoute.detailRoute.name,
          arguments: payload);
    });
  }

  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<RestoListProvider>().fetchRestoList();
    });
  }

  @override
  void dispose() {
    selectNotificationStream.close();
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
            key: const Key('searchButton'),
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
          _ => const SizedBox(
              key: Key('defaultState'),
            ),
        };
      }),
    );
  }
}
