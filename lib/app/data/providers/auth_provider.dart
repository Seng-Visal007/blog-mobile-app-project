import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../../services/api_service.dart';

class AuthProvider {
  final ApiService apiService = Get.find<ApiService>();

  Future<dio.Response> login({
    required String email,
    required String password,
  }) async {
    return await apiService.dio.post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }


  Future<dio.Response> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await apiService.dio.post(
      '/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  Future<dio.Response> currentUser() async {
    return await apiService.dio.get('/current-user');
  }

  Future<dio.Response> updateProfileImage(String imagePath) async {
    final formData = dio.FormData.fromMap({
      'image': await dio.MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      ),
    });

    return await apiService.dio.post(
      '/profile/image',
      data: formData,
    );
  }

  Future<dio.Response> logout() async {
    return await apiService.dio.post('/logout');
  }

  
}