import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/resto-response.dart';

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
      throw Exception('Failed to load detail of restaurant');
    }
  }

  Future<String> getImageUrl(String pictureId, ImageSize size) async {
    final sizeStr = size.toString().split('.').last;
    return '$_imageUrl$sizeStr/$pictureId';
  }
}
