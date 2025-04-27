import 'package:dio/dio.dart';
// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Core/Constants.dart';
import '../Domain/Model/PostModel.dart';

class ApiManager {
  final Dio _dio;

  ApiManager({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:8000/", // Change to your API URL
    connectTimeout: const Duration(seconds: 40),
    receiveTimeout: const Duration(seconds: 40),
  ));

  /// **GET Request**
  Future<Response<T>> get<T>(
      String endpoint, {
        Map<String, dynamic>? queryParams,
        Options? options,
      }) async {
    try {
      final response = await _dio.get<T>(
        endpoint,
        queryParameters: queryParams,
        options: options,
      );
      return response;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// **POST Request**
  Future<Response<T>> post<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParams,
        Options? options,
      }) async {
    try {
      final response = await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      return response;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// **Download an MP3 File as Bytes**
  Future<List<int>> downloadAudio(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data ?? [];
    } catch (e) {
      throw handleError(e);
    }
  }

  /// **Generic Error Handling**
  Exception handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Exception("Connection timeout. Please try again.");
        case DioExceptionType.receiveTimeout:
          return Exception("Receive timeout. Please try again.");
        case DioExceptionType.badResponse:
          return Exception(
              "Server error: ${error.response?.statusCode} - ${error.response?.statusMessage}");
        case DioExceptionType.cancel:
          return Exception("Request canceled.");
        default:
          return Exception("Unexpected error occurred.");
      }
    }
    return Exception("An unknown error occurred.");
  }
}

class ApiService {
  static const String url = 'https://thefluentme.p.rapidapi.com/post';
  static var headers = {
    'x-rapidapi-key': rapidApiKey,
    'x-rapidapi-host': rapidApiHost,
  };

  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        final List<dynamic> postsJson = decoded[1]['posts'];
        return postsJson.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Network Error: $e');
      throw Exception('Failed to fetch posts: $e');
    }
  }
}