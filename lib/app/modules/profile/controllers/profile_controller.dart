
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();

  final user = Rxn<UserModel>();
  final isLoading = false.obs;

  final ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    try {
      isLoading.value = true;

      final response = await authProvider.currentUser();

      user.value = UserModel.fromJson(response.data);
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data?['message']?.toString() ??
            'Failed to load profile.',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) {
        return;
      }

      isLoading.value = true;

      final response = await authProvider.updateProfileImage(
        image.path,
      );

      user.value = UserModel.fromJson(
        response.data['user'],
      );

      Get.snackbar(
        'Success',
        'Profile image updated successfully.',
      );
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Upload Failed',
        e.response?.data?['message']?.toString() ??
            'Failed to upload profile image.',
      );
    } catch (e) {
      Get.snackbar(
        'Upload Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
