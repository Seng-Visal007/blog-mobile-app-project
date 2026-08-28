import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../../services/api_service.dart';

class CommentProvider {
  final ApiService apiService = Get.find<ApiService>();

  Future<dio.Response> getComments(int postId) async {
    return await apiService.dio.get(
      '/comments',
      queryParameters: {
        'post_id': postId,
      },
    );
  }

  Future<dio.Response> createComment({
    required String content,
    required int postId,
  }) async {
    return await apiService.dio.post(
      '/comments',
      data: {
        'content': content,
        'post_id': postId,
      },
    );
  }
}