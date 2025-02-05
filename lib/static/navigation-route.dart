enum NavigationRoute {
  mainRoute("/"),
  searchRoute("/search"),
  detailRoute("/detail");

  const NavigationRoute(this.name);
  final String name;
}