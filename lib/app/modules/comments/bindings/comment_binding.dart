import 'package:get/get.dart';

import '../../../data/providers/comment_provider.dart';
import '../controllers/comment_controller.dart';

class CommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommentProvider>(
      () => CommentProvider(),
    );

    Get.lazyPut<CommentController>(
      () => CommentController(),
    );
  }
}

// Now GetX can create both:

// CommentProvider
//        ↓
// CommentController
//        ↓
// Comments UI