import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/restaurant_response.dart';

enum ImageSize { small, medium, large }

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _imageUrl = '$_baseUrl/images/';

  Future<RestoResponse> getRestaurants() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));
    if (response.statusCode == 200) {
      return RestoResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load list of restaurants');
    }
  }

  Future<RestoResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return RestoResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception();
    }
  }

  Future<String> getImageUrl(String pictureId, ImageSize size) async {
    final sizeStr = size.toString().split('.').last;
    return '$_imageUrl$sizeStr/$pictureId';
  }

  Future<RestoResponse> postReview(
      String id, String name, String review) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/review"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'name': name,
        'review': review,
      }),
    );
    if (response.statusCode == 201) {
      return RestoResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception();
    }
  }

  Future<RestoResponse> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));
    if (response.statusCode == 200) {
      return RestoResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception();
    }
  }
}
