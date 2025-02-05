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
    return FutureBuilder<String>(
      future: ApiService().getImageUrl(restaurant.pictureId, ImageSize.large),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return _buildDetail(context, snapshot.data!);
        } else {
          return const Center(child: Text('Failed to load image'));
        }
      },
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
                _buildTitle(context),
                const SizedBox(height: 8),
                _buildAddress(context),
                const SizedBox(height: 8),
                _buildCategories(context),
                const SizedBox(height: 8),
                Text(
                  restaurant.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Divider(),
                _buildFoods(context),
                const SizedBox(height: 8),
                const Divider(),
                _buildDrinks(context),
                const Divider(),
                _buildReviews(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildReviews(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Consumer<RestoReviewProvider>(
          builder: (context, reviewProvider, child) {
            return switch (reviewProvider.resultState) {
              RestoReviewResultLoading() =>
                const Center(child: CircularProgressIndicator()),
              RestoReviewResultNone() =>
                _buildReviewList(restaurant.customerReviews ?? []),
              RestoReviewResultLoaded(data: var reviews) =>
                _buildReviewList(reviews),
              RestoReviewResultError(error: var message) =>
                Center(child: Text(message)),
            };
          },
        ),
      ],
    );
  }

  Widget _buildReviewList(List<CustomerReview> reviews) {
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
                        minHeight: 100,
                        maxHeight: 100),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    review.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(review.date),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review.review,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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

  Widget _buildDrinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                            minWidth: 150,
                            maxWidth: 150,
                            minHeight: 100,
                            maxHeight: 100),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.local_drink),
                                const SizedBox(height: 8),
                                Text(
                                  drink.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFoods(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                            minWidth: 150,
                            maxWidth: 150,
                            minHeight: 100,
                            maxHeight: 100),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.fastfood),
                                const SizedBox(height: 8),
                                Text(
                                  food.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Colors.redAccent),
        const SizedBox(width: 8),
        Text(
          '${restaurant.city}, ${restaurant.address!}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            restaurant.name,
            style: Theme.of(context).textTheme.headlineMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 8),
            Text(
              restaurant.rating.toString(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ],
    );
  }
}
