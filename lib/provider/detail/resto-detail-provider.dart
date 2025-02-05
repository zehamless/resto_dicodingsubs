import 'package:flutter/material.dart';
import 'package:resto_dicodingsubs/static/resto-detail-result-state.dart';

import '../../api/api-service.dart';

class RestoDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestoDetailProvider(this._apiService);

  RestoDetailResultState _resultState = RestoDetailResultNone();

  RestoDetailResultState get resultState => _resultState;

  Future<void> fetchDetail(String restaurantId) async {
    try {
      _resultState = RestoDetailResultLoading();
      notifyListeners();
      final result = await _apiService.getRestaurantDetail(restaurantId);
      _resultState = result.error
          ? RestoDetailResultError(result.message)
          : result.restaurant != null
              ? RestoDetailResultLoaded(result.restaurant!)
              : RestoDetailResultError("Restaurant data is null");
    } on Exception {
      _resultState = RestoDetailResultError("Error fetching detail");
    }
    notifyListeners();
  }
}
