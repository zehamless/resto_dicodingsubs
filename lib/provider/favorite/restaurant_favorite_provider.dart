import 'package:flutter/foundation.dart';
import 'package:resto_dicodingsubs/service/sqlite_service.dart';
import 'package:resto_dicodingsubs/static/restaurant_list_result_state.dart';

import '../../model/restaurant.dart';

class RestaurantFavoriteProvider extends ChangeNotifier {
  final SqliteService _sqliteService;
  RestoListResultState _resultState = RestoListResultNone();
  final Map<String, bool> _favoriteStatus = {}; // Cache status favorite

  RestoListResultState get resultState => _resultState;

  RestaurantFavoriteProvider(this._sqliteService);

  Future<void> fetchRestaurantFavorites() async {
    try {
      _resultState = RestoListResultLoading();
      notifyListeners();
      final restaurants = await _sqliteService.getRestaurants();
      for (var resto in restaurants) {
        _favoriteStatus[resto.id] =
            true; // Tandai semua yang sudah di-favoritkan
      }
      if (restaurants.isEmpty) {
        _resultState = RestoListResultNone();
      } else {
        _resultState = RestoListResultLoaded(restaurants);
      }
    } catch (e) {
      _resultState = RestoListResultError("Error fetching data");
    }
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favoriteStatus[id] ?? false; // Ambil dari cache lokal
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (isFavorite(restaurant.id)) {
      await removeRestaurantFavorite(restaurant.id);
    } else {
      await addRestaurantFavorite(restaurant);
    }
  }

  Future<void> addRestaurantFavorite(Restaurant restaurant) async {
    _favoriteStatus[restaurant.id] = true; // Update cache sebelum async
    notifyListeners();
    await _sqliteService.insertRestaurant(restaurant);
  }

  Future<void> removeRestaurantFavorite(String id) async {
    _favoriteStatus[id] = false; // Update cache sebelum async
    notifyListeners();
    await _sqliteService.removeRestaurant(id);
  }
}
