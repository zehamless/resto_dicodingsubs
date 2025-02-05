import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/detail/resto-detail-provider.dart';
import 'package:resto_dicodingsubs/screen/detail/widget/review-form.dart';
import 'package:resto_dicodingsubs/utils/theme-changer.dart';

import '../../static/resto-detail-result-state.dart';
import 'detail-screen-widget.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestoDetailProvider>().fetchDetail(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Screen'),
          actions: [
            ThemeChanger(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add Review",
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ReviewForm(restaurantId: widget.restaurantId);
              },
            );
          },
          child: const Icon(Icons.reviews),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Consumer<RestoDetailProvider>(
          builder: (context, value, child) {
            return switch (value.resultState) {
              RestoDetailResultLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              RestoDetailResultLoaded(data: var resto) => DetailScreenWidget(
                  restaurant: resto,
                ),
              RestoDetailResultError(error: var message) => Center(
                  child: Text(message),
                ),
              _ => const SizedBox()
            };
          },
        ));
  }
}
