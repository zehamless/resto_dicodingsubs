import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/detail/resto-detail-provider.dart';

import '../../static/resto-detail-result-state.dart';

class DetailScreen extends StatefulWidget {
  final int restoId;

  const DetailScreen({super.key, required this.restoId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Screen'),
        ),
        body: Consumer<RestoDetailProvider>(
          builder: (context, value, child) {
            return switch (value.resultState) {
              RestoDetailResultLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              RestoDetailResultLoaded(data: var resto) => Column(
                  children: [
                    Text(resto.name),
                    Text(resto.description),
                  ],
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
