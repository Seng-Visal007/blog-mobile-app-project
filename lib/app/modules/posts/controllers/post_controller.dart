import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/post_model.dart';
import '../../../data/providers/post_provider.dart';

class PostController extends GetxController {
  final PostProvider provider = Get.find<PostProvider>();
  final GetStorage storage = GetStorage();
  final ImagePicker imagePicker = ImagePicker();

  final posts = <PostModel>[].obs;
  final isLoading = false.obs;
  final isCreating = false.obs;
  final selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    getPosts();
  }

  Future<void> getPosts() async {
    try {
      isLoading.value = true;

      final response = await provider.getPosts();

      final List data = response.data['data'] ?? [];

      posts.value = data
          .map(
            (json) => PostModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load posts',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<PostModel?> getPostById(int id) async {
    try {
      final response = await provider.getPostById(id);

      return PostModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load post',
      );

      return null;
    }
  }

  Future<void> refreshPosts() async {
    await getPosts();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> createPost({
    required String title,
  }) async {
    if (title.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a title.',
      );
      return;
    }

    if (selectedImage.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select an image.',
      );
      return;
    }

    final user = storage.read('user');

    if (user == null || user['id'] == null) {
      Get.snackbar(
        'Error',
        'User information not found. Please login again.',
      );
      return;
    }

    try {
      isCreating.value = true;

      await provider.createPost(
        title: title.trim(),
        userId: user['id'],
        image: selectedImage.value!,
      );

      selectedImage.value = null;
      Get.back(result: true);
      Get.snackbar(
        'Success',
        'Post created successfully.',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        duration: const Duration(seconds: 5),
      );
    } finally {
      isCreating.value = false;
    }
  }
}