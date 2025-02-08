import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/detail/restaurant_detail_provider.dart';
import 'package:resto_dicodingsubs/screen/detail/widget/review_form.dart';
import 'package:resto_dicodingsubs/utils/theme_changer.dart';

import '../../api/api_service.dart';
import '../../static/restaurant_detail_result_state.dart';
import 'detail_screen_widget.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<String> _imageUrlFuture;

  @override
  void initState() {
    super.initState();
    context.read<RestoDetailProvider>().fetchDetail(widget.restaurantId);
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
          switch (value.resultState) {
            case RestoDetailResultLoading():
              return const Center(child: CircularProgressIndicator());
            case RestoDetailResultLoaded(data: var resto):
              _imageUrlFuture =
                  ApiService().getImageUrl(resto.pictureId, ImageSize.large);
              return FutureBuilder<String>(
                future: _imageUrlFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return DetailScreenWidget(
                      restaurant: resto,
                      imageUrl: snapshot.data!,
                    );
                  } else {
                    return const Center(child: Text('Failed to load image'));
                  }
                },
              );
            case RestoDetailResultError(error: var message):
              return Center(child: Text(message));
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
