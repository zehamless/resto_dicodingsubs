import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_dicodingsubs/provider/detail/resto-review-provider.dart';

class ReviewForm extends StatefulWidget {
  final String restaurantId;

  const ReviewForm({super.key, required this.restaurantId});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Name cannot be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _reviewController,
              decoration: const InputDecoration(
                labelText: 'Review',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Review cannot be empty';
                }
                return null;
              },
            ),
            Consumer<RestoReviewProvider>(
              builder: (context, reviewProvider, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      reviewProvider.postReview(
                        widget.restaurantId,
                        _nameController.text,
                        _reviewController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Review submitted')),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
