class Category {
  Category({
    required this.name,
  });

  final String name;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
  };

}