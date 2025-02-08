import 'package:resto_dicodingsubs/model/restaurant.dart';
import 'package:resto_dicodingsubs/model/restaurant_review.dart';

class RestoResponse {
  RestoResponse({
    required this.error,
    required this.message,
    this.count,
    this.restaurants,
    this.restaurant,
    this.customerReviews,
  });

  final bool error;
  final String message;
  final num? count;
  final List<Restaurant>? restaurants;
  final Restaurant? restaurant;
  final List<CustomerReview>? customerReviews;

  factory RestoResponse.fromJson(Map<String, dynamic> json) => RestoResponse(
        error: json["error"],
        message: json["message"] ?? "No message",
        count: json["count"],
        restaurants: json["restaurants"] == null
            ? null
            : List<Restaurant>.from(
                json["restaurants"].map((x) => Restaurant.fromJson(x))),
        restaurant: json["restaurant"] == null
            ? null
            : Restaurant.fromJson(json["restaurant"]),
        customerReviews: json["customerReviews"] == null
            ? null
            : List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": restaurants?.map((x) => x.toJson()).toList(),
        "restaurant": restaurant?.toJson(),
        "customerReviews": customerReviews?.map((x) => x.toJson()).toList(),
      };
}
