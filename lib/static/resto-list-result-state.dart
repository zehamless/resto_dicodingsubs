import '../model/restaurant.dart';

sealed class RestoListResultState {}

class RestoListResultLoading extends RestoListResultState {}

class RestoListResultError extends RestoListResultState {
  final String error;

  RestoListResultError(this.error);
}

class RestoListResultNone extends RestoListResultState {}

class RestoListResultLoaded extends RestoListResultState {
  final List<Restaurant> data;

  RestoListResultLoaded(this.data);
}
