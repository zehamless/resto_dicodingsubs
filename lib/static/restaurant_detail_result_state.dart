import 'package:resto_dicodingsubs/model/restaurant.dart';

sealed class RestoDetailResultState {}

class RestoDetailResultLoading extends RestoDetailResultState {}

class RestoDetailResultError extends RestoDetailResultState {
  final String error;

  RestoDetailResultError(this.error);
}

class RestoDetailResultNone extends RestoDetailResultState {}

class RestoDetailResultLoaded extends RestoDetailResultState {
  final Restaurant data;

  RestoDetailResultLoaded(this.data);
}
