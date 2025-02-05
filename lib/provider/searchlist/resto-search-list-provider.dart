import 'package:flutter/cupertino.dart';
import 'package:resto_dicodingsubs/api/api-service.dart';
import 'package:resto_dicodingsubs/static/resto-list-result-state.dart';

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
    } on Exception catch (e) {
      _resultState = RestoListResultError(e.toString());
    }
    notifyListeners();
  }
}
