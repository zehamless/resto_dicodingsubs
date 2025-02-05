import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/model/restaurant.dart';

import '../../api/api-service.dart';
import '../../model/resto-review.dart';
import '../../provider/detail/resto-review-provider.dart';
import '../../static/resto-review-result-state.dart';

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return _buildDetail(context, snapshot.data as String);
          } else {
            return const Center(
              child: Text('Failed to load image'),
            );
          }
        });
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
                Consumer<RestoReviewProvider>(
                  builder: (context, reviewProvider, child) {
                    return switch (reviewProvider.resultState) {
                      RestoReviewResultLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      RestoReviewResultNone() =>
                        _buildReview(context, restaurant.customerReviews ?? []),
                      RestoReviewResultLoaded(data: var reviews) =>
                        _buildReview(context, reviews),
                      RestoReviewResultError(error: var message) => Center(
                          child: Text(message),
                        ),
                      _ => const SizedBox()
                    };
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(BuildContext context, List<CustomerReview> reviews) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: reviews
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
