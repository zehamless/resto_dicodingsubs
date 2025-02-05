import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/home/resto-list-provider.dart';
import 'package:resto_dicodingsubs/screen/home/resto-card-widget.dart';
import 'package:resto_dicodingsubs/utils/theme-changer.dart';

import '../../static/navigation-route.dart';
import '../../static/resto-list-result-state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestoListProvider>().fetchRestoList();
    });
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
          ThemeChanger(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, NavigationRoute.searchRoute.name);
            },
          ),
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
}
