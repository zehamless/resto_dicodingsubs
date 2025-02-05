import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/api/api-service.dart';
import 'package:resto_dicodingsubs/provider/detail/resto-detail-provider.dart';
import 'package:resto_dicodingsubs/provider/home/resto-list-provider.dart';
import 'package:resto_dicodingsubs/provider/style/theme-provider.dart';
import 'package:resto_dicodingsubs/screen/detail/detail-screen.dart';
import 'package:resto_dicodingsubs/screen/home/home-screen.dart';
import 'package:resto_dicodingsubs/static/navigation-route.dart';
import 'package:resto_dicodingsubs/style/theme/resto-theme.dart';
import 'package:resto_dicodingsubs/style/typography/resto-text-typography.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => ApiService()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
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
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Poppins", "Montserrat");

    MaterialTheme theme = MaterialTheme(textTheme);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeProvider.themeMode == ThemeMode.light
              ? theme.light()
              : theme.dark(),
          initialRoute: NavigationRoute.mainRoute.name,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const HomeScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
                  restoId: ModalRoute.of(context)?.settings.arguments as String,
                ),
          },
        );
      },
    );
  }
}
