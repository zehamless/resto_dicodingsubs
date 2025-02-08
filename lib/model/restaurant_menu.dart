import 'package:resto_dicodingsubs/model/restaurant_category.dart';

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });

  final List<Category> foods;
  final List<Category> drinks;

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: json["foods"] == null
          ? []
          : List<Category>.from(
              json["foods"]!.map((x) => Category.fromJson(x))),
      drinks: json["drinks"] == null
          ? []
          : List<Category>.from(
              json["drinks"]!.map((x) => Category.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "foods": foods.map((x) => x.toJson()).toList(),
        "drinks": drinks.map((x) => x.toJson()).toList(),
      };
}

