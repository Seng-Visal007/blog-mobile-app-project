import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../../services/api_service.dart';

class PostProvider {
  final ApiService apiService = Get.find<ApiService>();

  Future<dio.Response> getPosts() async {
    return await apiService.dio.get('/posts');
  }

  Future<dio.Response> getPostById(int id) async {
    return await apiService.dio.get('/posts/$id');
}

  Future<dio.Response> createPost({
    required String title,
    required int userId,
    required File image,
  }) async {
    final formData = dio.FormData.fromMap({
      'title': title,
      'user_id': userId.toString(),
      'image': await dio.MultipartFile.fromFile(
        image.path,
      ),
    });

    return await apiService.dio.post(
      '/posts',
      data: formData,
    );
  }
}