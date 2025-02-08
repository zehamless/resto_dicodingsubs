import 'package:flutter/material.dart';
import 'package:resto_dicodingsubs/api/api_service.dart';
import 'package:resto_dicodingsubs/static/restaurant_review_result_state.dart';

class RestoReviewProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestoReviewProvider(this._apiService);

  RestoReviewResultState _resultState = RestoReviewResultNone();

  RestoReviewResultState get resultState => _resultState;

  Future<void> postReview(String id, String name, String review) async {
    try {
      _resultState = RestoReviewResultLoading();
      notifyListeners();
      final result = await _apiService.postReview(id, name, review);
      _resultState = result.error
          ? RestoReviewResultError(result.message)
          : result.customerReviews != null
              ? RestoReviewResultLoaded(result.customerReviews!)
              : RestoReviewResultError("Customer review data is null");
    } on Exception {
      _resultState = RestoReviewResultError("Error posting review");
    }
    notifyListeners();
  }
}
