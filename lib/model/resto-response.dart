import 'package:resto_dicodingsubs/model/restaurant.dart';

class RestoResponse {
  RestoResponse({
    required this.error,
    required this.message,
    this.count,
    this.restaurants,
    this.restaurant,
  });

  final bool error;
  final String message;
  final num? count;
  final List<Restaurant>? restaurants;
  final Restaurant? restaurant;

  factory RestoResponse.fromJson(Map<String, dynamic> json) => RestoResponse(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: json["restaurants"] == null
            ? null
            : List<Restaurant>.from(
                json["restaurants"].map((x) => Restaurant.fromJson(x))),
        restaurant: json["restaurant"] == null
            ? null
            : Restaurant.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": restaurants?.map((x) => x.toJson()).toList(),
        "restaurant": restaurant?.toJson(),
      };
}
