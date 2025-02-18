import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/api/api_service.dart';
import 'package:resto_dicodingsubs/provider/detail/restaurant_detail_provider.dart';
import 'package:resto_dicodingsubs/provider/detail/restaurant_review_provider.dart';
import 'package:resto_dicodingsubs/provider/favorite/restaurant_favorite_provider.dart';
import 'package:resto_dicodingsubs/provider/home/restaurant_list_provider.dart';
import 'package:resto_dicodingsubs/provider/index_nav_provider.dart';
import 'package:resto_dicodingsubs/provider/searchlist/restaurant_search_list_provider.dart';
import 'package:resto_dicodingsubs/provider/style/theme_provider.dart';
import 'package:resto_dicodingsubs/screen/detail/detail_screen.dart';
import 'package:resto_dicodingsubs/screen/favorite/favorite_screen.dart';
import 'package:resto_dicodingsubs/screen/home/home_screen.dart';
import 'package:resto_dicodingsubs/screen/main.dart';
import 'package:resto_dicodingsubs/screen/searchlist/restaurant_search_list_screen.dart';
import 'package:resto_dicodingsubs/service/shared_preferences_service.dart';
import 'package:resto_dicodingsubs/service/sqlite_service.dart';
import 'package:resto_dicodingsubs/static/navigation_route.dart';
import 'package:resto_dicodingsubs/style/theme/restaurant_theme.dart';
import 'package:resto_dicodingsubs/style/typography/restaurant_text_typography.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => ApiService()),
      Provider(
          create: (context) => SharedPreferencesService(sharedPreferences)),
      Provider(create: (context) => SqliteService()),
      ChangeNotifierProvider(
          create: (context) =>
              RestaurantFavoriteProvider(context.read<SqliteService>())),
      ChangeNotifierProvider(
          create: (context) =>
              ThemeProvider(context.read<SharedPreferencesService>())),
      ChangeNotifierProvider(
          create: (context) => RestoReviewProvider(context.read<ApiService>())),
      ChangeNotifierProvider(
          create: (context) => RestoSearchProvider(context.read<ApiService>())),
      ChangeNotifierProvider(
          create: (context) => RestoDetailProvider(context.read<ApiService>())),
      ChangeNotifierProvider(
          create: (context) => RestoListProvider(context.read<ApiService>())),
      ChangeNotifierProvider(create: (context) => IndexNavProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Montserrat");

    MaterialTheme theme = MaterialTheme(textTheme);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: themeProvider.themeMode,
          home: const MainScreen(),
          routes: {
            NavigationRoute.mainRoute.name: (context) => const HomeScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String,
                ),
            NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
            NavigationRoute.favoriteRoute.name: (context) =>
                const FavoriteScreen(),
          },
        );
      },
    );
  }
}
