import 'package:flutter/cupertino.dart';
import 'package:resto_dicodingsubs/api/api_service.dart';
import 'package:resto_dicodingsubs/static/restaurant_list_result_state.dart';

class RestoSearchProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestoSearchProvider(this._apiService);

  RestoListResultState _resultState = RestoListResultNone();

  RestoListResultState get resultState => _resultState;

  Future<void> fetchRestoByQuery(String query) async {
    try {
      _resultState = RestoListResultLoading();
      notifyListeners();
      final result = await _apiService.searchRestaurants(query);
      _resultState = result.error
          ? RestoListResultError(result.message)
          : RestoListResultLoaded(result.restaurants ?? []);
    } on Exception {
      _resultState = RestoListResultError("Error fetching restaurants");
    }
    notifyListeners();
  }
}
