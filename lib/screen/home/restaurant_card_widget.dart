import 'package:flutter/material.dart';
import 'package:resto_dicodingsubs/model/restaurant.dart';

class RestoCard extends StatelessWidget {
  final Restaurant restaurant;
  final void Function()? onTap;
  final String imageUrl;

  const RestoCard({
    super.key,
    required this.restaurant,
    this.onTap,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(context, imageUrl);
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
}
