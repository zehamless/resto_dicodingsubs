import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/favorite/restaurant_favorite_provider.dart';

import '../model/restaurant.dart';

class FavoriteIconHandler extends StatelessWidget {
  final Restaurant restaurant;

  const FavoriteIconHandler({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantFavoriteProvider>(
      builder: (context, provider, child) {
        bool isFavorite = provider.isFavorite(restaurant.id);
        return IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.white.withAlpha(100),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_outline,
              size: 30,
              color: isFavorite ? Colors.redAccent : Colors.white,
            ),
          ),
          onPressed: () {
            provider.toggleFavorite(restaurant);
          },
        );
      },
    );
  }
}
