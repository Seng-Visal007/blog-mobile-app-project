import 'package:get/get.dart';

import '../../../data/providers/post_provider.dart';
import '../controllers/post_controller.dart';

import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../data/providers/auth_provider.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostProvider>(
      () => PostProvider(),
    );

    Get.lazyPut<PostController>(
      () => PostController(),
    );

    Get.lazyPut<AuthProvider>(
      () => AuthProvider(),
    );

    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}