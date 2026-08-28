import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/user_model.dart';
import 'package:dio/dio.dart' as dio;

class AuthController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();
  final GetStorage storage = GetStorage();
  

  final isLoading = false.obs;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      final response = await authProvider.login(
        email: email,
        password: password,
      );

      final token = response.data['token'] ??
          response.data['access_token'];

      if (token != null) {
        final user = UserModel.fromJson(response.data['user']);

        await storage.write('token', token);
        await storage.write('user', user.toJson());

        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          'Login Failed',
          'Token was not returned by the server.',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        'Invalid email or password.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    isLoading.value = true;

    try {
      final response = await authProvider.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      final token = response.data['access_token'];

      if (token != null) {
        final user = UserModel.fromJson(
          response.data['data'],
        );

        await storage.write('token', token);
        await storage.write('user', user.toJson());

        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          'Registration Failed',
          'Token was not returned by the server.',
        );
      }
    } on dio.DioException catch (e) {
      String message = 'Registration failed.';

      if (e.response?.data != null) {
        final data = e.response!.data;

        if (data['errors'] != null) {
          final errors = data['errors'] as Map;

          message = errors.values
              .expand((error) => error is List ? error : [error])
              .join('\n');
        } else if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      Get.snackbar(
        'Registration Failed',
        message,
      );
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      isLoading.value = true;

      final response = await authProvider.currentUser();

      final user = UserModel.fromJson(response.data);

      await storage.write('user', user.toJson());

      return user;
    } on dio.DioException catch (e) {
      String message = 'Failed to load user information.';

      if (e.response?.data != null) {
        final data = e.response!.data;

        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      Get.snackbar(
        'Error',
        message,
      );

      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
      );

      return null;
    } finally {
      isLoading.value = false;
    }
  }

    Future<void> logout() async {
    try {
      isLoading.value = true;

      await authProvider.logout();

      await storage.remove('token');
      await storage.remove('user');

      Get.offAllNamed(AppRoutes.login);

    } catch (e) {
      Get.snackbar(
        'Logout Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}