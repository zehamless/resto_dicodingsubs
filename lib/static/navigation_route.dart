enum NavigationRoute {
  mainRoute("/home"),
  searchRoute("/search"),
  detailRoute("/detail"),
  favoriteRoute("/favorite");

  const NavigationRoute(this.name);
  final String name;
}