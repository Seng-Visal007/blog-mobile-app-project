import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/post_controller.dart';
import '../../comments/controllers/comment_controller.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/post_model.dart';

class PostDetailView extends StatefulWidget {
  const PostDetailView({super.key});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  final PostController controller = Get.find<PostController>();
  final CommentController commentController = Get.find<CommentController>();
  final TextEditingController _commentController =
    TextEditingController();

  PostModel? currentPost;
  @override
  void initState() {
    super.initState();

    final int postId = Get.arguments as int;

    commentController.getComments(postId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int postId = Get.arguments as int;

    return Scaffold(
      appBar: AppBar(
      title: const Text('Post Details'),
      actions: [
        IconButton(
          onPressed: () {
            if (currentPost != null) {
              SharePlus.instance.share(
                ShareParams(
                  text: '${currentPost!.title}\n\nCheck out this post!',
                ),
              );
            }
          },
          icon: const Icon(Icons.ios_share),
        ),
      ],
    ),
      body: FutureBuilder(
        future: controller.getPostById(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text(
                'Failed to load post',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final post = snapshot.data!;
          currentPost = post;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.image != null)
                  Image.network(
                    '${controller.provider.apiService.dio.options.baseUrl.replaceFirst('/api', '')}/storage/${post.image}',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 250,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 60,
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
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'By: ${post.user?.name ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      if (post.createdAt != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          post.createdAt!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],

                      const SizedBox(height: 25),

                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Obx(() {
                        if (commentController.isLoading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (commentController.comments.isEmpty) {
                          return Text(
                            'No comments yet.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          );
                        }

                        return Column(
                          children: commentController.comments.map(
                            (comment) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(
                                  comment.user?.name ?? 'Unknown User',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  comment.content ?? '',
                                ),
                              );
                            },
                          ).toList(),
                        );
                      }),
                      const SizedBox(height: 20),

                      TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              commentController.createComment(
                                content: _commentController.text,
                                postId: postId,
                              );

                              _commentController.clear();
                            },
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

