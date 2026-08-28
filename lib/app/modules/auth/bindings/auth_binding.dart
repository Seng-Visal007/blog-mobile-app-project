import 'package:get/get.dart';

import '../../../data/providers/auth_provider.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(
      () => AuthProvider(),
    );

    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}