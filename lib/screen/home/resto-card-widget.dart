import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resto_dicodingsubs/api/api-service.dart';
import 'package:resto_dicodingsubs/model/restaurant.dart';
import 'package:shimmer/shimmer.dart';

class RestoCard extends StatelessWidget {
  final Restaurant resto;
  final void Function()? onTap;

  const RestoCard({
    super.key,
    required this.resto,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return FutureBuilder(
      future:
          _loadImage(apiService.getImageUrl(resto.pictureId, ImageSize.small)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerCard();
        } else {
          return _buildCard(context, apiService);
        }
      },
    );
  }

  Future<void> _loadImage(String url) async {
    final image = NetworkImage(url);
    final completer = Completer<void>();
    final listener = ImageStreamListener((_, __) => completer.complete());
    image.resolve(const ImageConfiguration()).addListener(listener);
    await completer.future;
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 50,
                    height: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, ApiService apiService) {
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
                child: ImageHero(resto: resto, apiService: apiService),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resto.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.pin_drop),
                      const SizedBox(width: 4),
                      Text(
                        resto.city,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star),
                      const SizedBox(width: 4),
                      Text(
                        resto.rating.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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

class ImageHero extends StatelessWidget {
  const ImageHero({
    super.key,
    required this.resto,
    required this.apiService,
  });

  final Restaurant resto;
  final ApiService apiService;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: resto.name,
      child: Image.network(
        apiService.getImageUrl(resto.pictureId, ImageSize.small),
        fit: BoxFit.cover,
      ),
    );
  }
}
