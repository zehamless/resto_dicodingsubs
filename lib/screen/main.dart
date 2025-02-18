import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/index_nav_provider.dart';
import 'package:resto_dicodingsubs/screen/favorite/favorite_screen.dart';
import 'package:resto_dicodingsubs/screen/home/home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          switch (value.index) {
            case 0:
              return HomeScreen();
            case 1:
              return FavoriteScreen();
            default:
              return HomeScreen();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<IndexNavProvider>().index,
        onTap: (index) {
          context.read<IndexNavProvider>().setIndex = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
