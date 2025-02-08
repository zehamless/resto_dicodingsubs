import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/api/api_service.dart';
import 'package:resto_dicodingsubs/provider/detail/restaurant_detail_provider.dart';
import 'package:resto_dicodingsubs/provider/detail/restaurant_review_provider.dart';
import 'package:resto_dicodingsubs/provider/home/restaurant_list_provider.dart';
import 'package:resto_dicodingsubs/provider/searchlist/restaurant_search_list_provider.dart';
import 'package:resto_dicodingsubs/provider/style/theme_provider.dart';
import 'package:resto_dicodingsubs/screen/detail/detail_screen.dart';
import 'package:resto_dicodingsubs/screen/home/home_screen.dart';
import 'package:resto_dicodingsubs/screen/searchlist/restaurant_search_list_screen.dart';
import 'package:resto_dicodingsubs/static/navigation_route.dart';
import 'package:resto_dicodingsubs/style/theme/restaurant_theme.dart';
import 'package:resto_dicodingsubs/style/typography/restaurant_text_typography.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => ApiService()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(
          create: (context) => RestoReviewProvider(context.read<ApiService>())),
      ChangeNotifierProvider(
          create: (context) => RestoSearchProvider(context.read<ApiService>())),
      ChangeNotifierProvider(
          create: (context) => RestoDetailProvider(context.read<ApiService>())),
      ChangeNotifierProvider(
          create: (context) => RestoListProvider(context.read<ApiService>())),
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
          initialRoute: NavigationRoute.mainRoute.name,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const HomeScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String,
                ),
            NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
          },
        );
      },
    );
  }
}
