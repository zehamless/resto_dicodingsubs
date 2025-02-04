import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/api/api-service.dart';
import 'package:resto_dicodingsubs/provider/detail/resto-detail-provider.dart';
import 'package:resto_dicodingsubs/provider/home/resto-list-provider.dart';
import 'package:resto_dicodingsubs/screen/detail/detail-screen.dart';
import 'package:resto_dicodingsubs/screen/main-screen.dart';
import 'package:resto_dicodingsubs/static/navigation-route.dart';
import 'package:resto_dicodingsubs/style/theme/resto-theme.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider(create: (context) => ApiService()),
    ChangeNotifierProvider(
        create: (context) => RestoDetailProvider(context.read<ApiService>())),
    ChangeNotifierProvider(
        create: (context) => RestoListProvider(context.read<ApiService>())),
  ], child: const MyApp()));
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
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
              restoId: ModalRoute.of(context)?.settings.arguments as String,
            ),
      },
    );
  }
}
