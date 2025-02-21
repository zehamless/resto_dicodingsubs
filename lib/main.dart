import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/api/api_service.dart';
import 'package:resto_dicodingsubs/provider/detail/restaurant_detail_provider.dart';
import 'package:resto_dicodingsubs/provider/detail/restaurant_review_provider.dart';
import 'package:resto_dicodingsubs/provider/favorite/restaurant_favorite_provider.dart';
import 'package:resto_dicodingsubs/provider/home/restaurant_list_provider.dart';
import 'package:resto_dicodingsubs/provider/index_nav_provider.dart';
import 'package:resto_dicodingsubs/provider/notification/local_notification_provider.dart';
import 'package:resto_dicodingsubs/provider/notification/payload_provider.dart';
import 'package:resto_dicodingsubs/provider/searchlist/restaurant_search_list_provider.dart';
import 'package:resto_dicodingsubs/provider/style/theme_provider.dart';
import 'package:resto_dicodingsubs/screen/detail/detail_screen.dart';
import 'package:resto_dicodingsubs/screen/favorite/favorite_screen.dart';
import 'package:resto_dicodingsubs/screen/main_screen.dart';
import 'package:resto_dicodingsubs/screen/searchlist/restaurant_search_list_screen.dart';
import 'package:resto_dicodingsubs/screen/setting/setting_screen.dart';
import 'package:resto_dicodingsubs/service/http_service.dart';
import 'package:resto_dicodingsubs/service/local_notification_service.dart';
import 'package:resto_dicodingsubs/service/shared_preferences_service.dart';
import 'package:resto_dicodingsubs/service/sqlite_service.dart';
import 'package:resto_dicodingsubs/service/workmanager_service.dart';
import 'package:resto_dicodingsubs/static/navigation_route.dart';
import 'package:resto_dicodingsubs/style/theme/restaurant_theme.dart';
import 'package:resto_dicodingsubs/style/typography/restaurant_text_typography.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String route = NavigationRoute.mainRoute.name;
  String? payload;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final notificationResponse =
        notificationAppLaunchDetails!.notificationResponse;
    route = NavigationRoute.detailRoute.name;
    payload = notificationResponse?.payload;
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiService()),
        Provider(
            create: (context) => SharedPreferencesService(sharedPreferences)),
        Provider(create: (context) => SqliteService()),
        Provider(create: (context) => HttpService()),
        ChangeNotifierProvider(
          create: (context) => PayloadProvider(payload: payload),
        ),
        Provider(
            create: (context) =>
                LocalNotificationService(context.read<HttpService>())..init()),
        Provider(create: (context) => WorkmanagerService()..init()),
        ChangeNotifierProvider(
            create: (context) => LocalNotificationProvider(
                context.read<LocalNotificationService>(),
                sharedPreferences,
                context.read<WorkmanagerService>())
              ..requestPermissions()),
        ChangeNotifierProvider(
            create: (context) =>
                RestaurantFavoriteProvider(context.read<SqliteService>())),
        ChangeNotifierProvider(
            create: (context) =>
                ThemeProvider(context.read<SharedPreferencesService>())),
        ChangeNotifierProvider(
            create: (context) =>
                RestoReviewProvider(context.read<ApiService>())),
        ChangeNotifierProvider(
            create: (context) =>
                RestoSearchProvider(context.read<ApiService>())),
        ChangeNotifierProvider(
            create: (context) =>
                RestoDetailProvider(context.read<ApiService>())),
        ChangeNotifierProvider(
            create: (context) => RestoListProvider(context.read<ApiService>())),
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
      ],
      child: MyApp(route: route),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String route;

  const MyApp({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Montserrat");
    MaterialTheme theme = MaterialTheme(textTheme);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: themeProvider.themeMode,
          initialRoute: route,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.detailRoute.name: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              final restaurantId = args != null
                  ? args as String
                  : Provider.of<PayloadProvider>(context, listen: false)
                      .payload;
              return DetailScreen(restaurantId: restaurantId!);
            },
            NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
            NavigationRoute.favoriteRoute.name: (context) =>
                const FavoriteScreen(),
            NavigationRoute.settingsRoute.name: (context) =>
                const SettingScreen(),
          },
        );
      },
    );
  }
}
