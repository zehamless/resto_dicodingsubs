import 'package:flutter/material.dart';
import 'package:resto_dicodingsubs/api/api-service.dart';
import 'package:resto_dicodingsubs/model/restaurant.dart';

class RestoCard extends StatelessWidget {
  final Restaurant restaurant;
  final void Function()? onTap;

  const RestoCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return FutureBuilder(
      future: apiService.getImageUrl(restaurant.pictureId, ImageSize.small),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return _buildCard(context, snapshot.data as String);
        } else {
          return _buildErrorCard(context);
        }
      },
    );
  }

  Widget _buildCard(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 120,
                maxWidth: 120,
                minHeight: 80,
                minWidth: 80,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: restaurant.id,
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.pin_drop,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(restaurant.city,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.error, color: Colors.red),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Error loading image',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Please try again later',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
