import 'package:get/get.dart';

import '../../../data/providers/auth_provider.dart';
import '../controllers/profile_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(
      () => AuthProvider(),
    );

    Get.lazyPut<AuthController>(
      () => AuthController(),
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}