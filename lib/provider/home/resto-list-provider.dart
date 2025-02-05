import 'package:flutter/cupertino.dart';
import 'package:resto_dicodingsubs/api/api-service.dart';
import 'package:resto_dicodingsubs/static/resto-list-result-state.dart';

class RestoListProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestoListProvider(this._apiService);

  RestoListResultState _resultState = RestoListResultNone();

  RestoListResultState get resultState => _resultState;

  Future<void> fetchRestoList() async {
    try {
      _resultState = RestoListResultLoading();
      notifyListeners();
      final result = await _apiService.getRestaurants();
      _resultState = result.error
          ? RestoListResultError(result.message)
          : RestoListResultLoaded(result.restaurants ?? []);
    } on Exception {
      _resultState = RestoListResultError("Error fetching data");
    }
    notifyListeners();
  }
}
