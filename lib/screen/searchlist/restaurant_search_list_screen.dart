import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/searchlist/restaurant_search_list_provider.dart';
import 'package:resto_dicodingsubs/screen/home/restaurant_card_widget.dart';

import '../../api/api_service.dart';
import '../../static/navigation_route.dart';
import '../../static/restaurant_list_result_state.dart';
import '../../utils/theme_changer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchPressed() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      context.read<RestoSearchProvider>().fetchRestoByQuery(query);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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
        actions: [ThemeChanger()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search restaurants...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Ink(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: _onSearchPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<RestoSearchProvider>(builder: (context, value, child) {
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
          _ => const SizedBox(),
        };
      }),
    );
  }
}
