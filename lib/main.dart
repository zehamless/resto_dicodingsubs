import 'package:flutter/material.dart';
import 'package:resto_dicodingsubs/static/navigation-route.dart';
import 'package:resto_dicodingsubs/style/theme/resto-theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: RestoTheme.lightTheme,
      darkTheme: RestoTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        NavigationRoute.detailRoute.name: (context) => const DetailScreen(
          restoId: ModalRoute.of(context)?.settings.arguments as int,
        ),
      },
    );
  }
}

