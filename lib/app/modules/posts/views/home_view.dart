import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/post_controller.dart';
import '../../../routes/app_routes.dart';

import '../../../services/api_service.dart';

class HomeView extends GetView<PostController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.profile);
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () async {
              final result = await Get.toNamed(
                AppRoutes.createPost,
              );

              if (result == true) {
                await controller.refreshPosts();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.posts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.posts.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshPosts,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 250),
                Center(
                  child: Text(
                    'No posts available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshPosts,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];

              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.postDetails,
                    arguments: post.id,
                  );
                },

                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post.image != null)
                        Image.network(
                          '${ApiService.baseUrl.replaceFirst('/api', '')}/storage/${post.image}',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,

                          loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                          ) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },

                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                ),
                              ),
                            );
                          },
                        ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title ?? 'Untitled',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'By: ${post.user?.name ?? 'Unknown'}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),

                            if (post.createdAt != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                post.createdAt!,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            const SizedBox(height: 15),

                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  Get.dialog(
                                    AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text(
                                        'Delete Post',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: const Text(
                                        'Are you sure you want to delete this post?',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      actionsPadding: const EdgeInsets.fromLTRB(
                                        16,
                                        0,
                                        16,
                                        16,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                            controller.deletePost(post.id);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}