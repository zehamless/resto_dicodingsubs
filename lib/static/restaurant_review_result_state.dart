import '../model/restaurant_review.dart';

sealed class RestoReviewResultState {}

class RestoReviewResultLoading extends RestoReviewResultState {}

class RestoReviewResultError extends RestoReviewResultState {
  final String error;

  RestoReviewResultError(this.error);
}

class RestoReviewResultNone extends RestoReviewResultState {}

class RestoReviewResultLoaded extends RestoReviewResultState {
  final List<CustomerReview> data;

  RestoReviewResultLoaded(this.data);
}
