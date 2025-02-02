import 'package:resto_dicodingsubs/model/restaurant.dart';

class RestoResponse {
  RestoResponse({
    required this.error,
    required this.message,
    this.count,
    required this.restaurants,
  });

  final bool error;
  final String message;
  final num? count;
  final List<Restaurant> restaurants;

  factory RestoResponse.fromJson(Map<String, dynamic> json){
    return RestoResponse(
      error: json["error"],
      message: json["message"],
      count: json["count"],
      restaurants: json["restaurants"] == null ? [] : List<Restaurant>.from(json["restaurants"]!.map((x) => Restaurant.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "count": count,
    "restaurants": restaurants.map((x) => x.toJson()).toList(),
  };

}