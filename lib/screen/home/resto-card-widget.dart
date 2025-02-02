import 'package:flutter/material.dart';

class RestoCard extends StatelessWidget {
  const RestoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
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
                    tag: 'Title',
                    child: Image.network(
                      'https://picsum.photos/400/300',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox.square(
                dimension: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Title',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox.square(
                      dimension: 8,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.pin_drop),
                        const SizedBox.square(
                          dimension: 4,
                        ),
                        Text(
                          'Location',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox.square(
                      dimension: 8,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star),
                        const SizedBox.square(
                          dimension: 4,
                        ),
                        Text(
                          'Rating',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
