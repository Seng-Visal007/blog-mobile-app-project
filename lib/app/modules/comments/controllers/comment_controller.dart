import 'package:get/get.dart';

import '../../../data/models/comment_model.dart';
import '../../../data/providers/comment_provider.dart';

class CommentController extends GetxController {
  final CommentProvider provider = Get.find<CommentProvider>();

  final comments = <CommentModel>[].obs;
  final isLoading = false.obs;

  Future<void> getComments(int postId) async {
    try {
      isLoading.value = true;

      final response = await provider.getComments(postId);

      final List data = response.data ?? [];

      comments.value = data
          .map(
            (json) => CommentModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load comments',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createComment({
    required String content,
    required int postId,
  }) async {
    if (content.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please write a comment.',
      );
      return;
    }

    try {
      isLoading.value = true;

      await provider.createComment(
        content: content.trim(),
        postId: postId,
      );

      Get.snackbar(
        'Success',
        'Comment added successfully.',
      );

      await getComments(postId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add comment.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}