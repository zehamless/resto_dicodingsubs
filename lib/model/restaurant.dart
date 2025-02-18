import 'package:resto_dicodingsubs/model/restaurant_category.dart';
import 'package:resto_dicodingsubs/model/restaurant_menu.dart';
import 'package:resto_dicodingsubs/model/restaurant_review.dart';

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    this.address,
    required this.pictureId,
    this.categories,
    this.menus,
    required this.rating,
    this.customerReviews,
  });

  final String id;
  final String name;
  final String description;
  final String city;
  final String? address;
  final String pictureId;
  final List<Category>? categories;
  final Menu? menus;
  final num rating;
  final List<CustomerReview>? customerReviews;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      address: json["address"] ?? '',
      pictureId: json["pictureId"],
      categories: json["categories"] == null
          ? null
          : List<Category>.from(
              json["categories"]!.map((x) => Category.fromJson(x))),
      menus: json["menus"] == null ? null : Menu.fromJson(json["menus"]),
      rating: json["rating"],
      customerReviews: json["customerReviews"] == null
          ? null
          : List<CustomerReview>.from(
              json["customerReviews"]!.map((x) => CustomerReview.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "categories": categories?.map((x) => x.toJson()).toList(),
        "menus": menus?.toJson(),
        "rating": rating,
        "customerReviews": customerReviews?.map((x) => x.toJson()).toList(),
      };
}

