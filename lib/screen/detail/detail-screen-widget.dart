import 'package:flutter/material.dart';
import 'package:resto_dicodingsubs/model/restaurant.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/api-service.dart';

class DetailScreenWidget extends StatelessWidget {
  final Restaurant restaurant;

  const DetailScreenWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    return FutureBuilder(
        future: apiService.getImageUrl(restaurant.pictureId, ImageSize.large),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerDetail(context);
          } else if (snapshot.hasData) {
            return _buildDetail(context, snapshot.data as String);
          } else {
            return _buildErrorDetail(context);
          }
        });
  }

  Widget _buildShimmerDetail(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: double.infinity, height: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 200, height: 20, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(
                      width: double.infinity, height: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Container(
                      width: double.infinity, height: 200, color: Colors.white),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Container(width: 100, height: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(
                      width: double.infinity, height: 80, color: Colors.white),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Container(width: 100, height: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(
                      width: double.infinity, height: 80, color: Colors.white),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Container(
                      width: double.infinity, height: 80, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, String imageUrl) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star),
                        const SizedBox(width: 8),
                        Text(restaurant.rating.toString()),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on),
                    const SizedBox(width: 8),
                    Text(
                      '${restaurant.city}, ${restaurant.address!}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: restaurant.categories!
                        .map((category) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Chip(
                                label: Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(),
                Text(
                  'Foods',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: restaurant.menus!.foods
                        .map((food) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.fastfood),
                                      // Add an icon above the label
                                      const SizedBox(height: 8),
                                      // Add some space between the icon and the label
                                      Text(food.name),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                Text(
                  'Drinks',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: restaurant.menus!.drinks
                        .map((drink) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.local_drink),
                                      // Add an icon above the label
                                      const SizedBox(height: 8),
                                      // Add some space between the icon and the label
                                      Text(drink.name),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const Divider(),
                Text(
                  'Reviews',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: restaurant.customerReviews!
                        .map((review) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 280,
                                  maxWidth: 280,
                                ),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(review.name),
                                            Text(review.date),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          review.review,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDetail(BuildContext context) {
    return Center(
      child: Text('Error'),
    );
  }
}
