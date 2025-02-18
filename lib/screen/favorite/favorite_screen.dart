import 'package:flutter/material.dart';

import '../../static/navigation_route.dart';
import '../../utils/theme_changer.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

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
          ThemeChanger(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, NavigationRoute.searchRoute.name);
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Favorite Screen'),
      ),
    );
  }
}
