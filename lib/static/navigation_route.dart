enum NavigationRoute {
  mainRoute("/home"),
  searchRoute("/search"),
  detailRoute("/detail"),
  settingsRoute("/settings"),
  favoriteRoute("/favorite");

  const NavigationRoute(this.name);
  final String name;
}