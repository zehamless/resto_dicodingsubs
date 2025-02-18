import 'package:flutter/foundation.dart';
import 'package:resto_dicodingsubs/service/sqlite_service.dart';

import '../../model/restaurant.dart';

class RestaurantFavoriteProvider extends ChangeNotifier {
  final SqliteService _sqliteService;
  List<Restaurant> _restaurantFavorites = [];

  RestaurantFavoriteProvider(this._sqliteService) {
    fetchRestaurantFavorites();
  }

  List<Restaurant> get restaurantFavorites => _restaurantFavorites;

  /// Mengambil daftar restoran favorit dari database
  Future<void> fetchRestaurantFavorites() async {
    _restaurantFavorites = await _sqliteService.getRestaurants();
    notifyListeners();
  }

  /// Mengecek apakah restoran dengan ID tertentu adalah favorit
  bool isFavorite(String id) {
    return _restaurantFavorites.any((restaurant) => restaurant.id == id);
  }

  /// Menambahkan atau menghapus restoran dari daftar favorit
  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (isFavorite(restaurant.id)) {
      await removeRestaurantFavorite(restaurant.id);
    } else {
      await addRestaurantFavorite(restaurant);
    }
  }

  /// Menambahkan restoran ke favorit
  Future<void> addRestaurantFavorite(Restaurant restaurant) async {
    await _sqliteService.insertRestaurant(restaurant);
    await fetchRestaurantFavorites();
  }

  /// Menghapus restoran dari favorit
  Future<void> removeRestaurantFavorite(String id) async {
    await _sqliteService.removeRestaurant(id);
    await fetchRestaurantFavorites();
  }
}
