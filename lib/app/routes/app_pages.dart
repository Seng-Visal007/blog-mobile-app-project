import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/posts/views/home_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/posts/bindings/post_binding.dart';
import '../modules/posts/views/create_post_view.dart';
import '../modules/posts/views/post_detail_view.dart';
import '../modules/comments/bindings/comment_binding.dart';
import '../modules/profile/bindings/profile_binding.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: PostBinding(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.createPost,
      page: () => const CreatePostView(),
      binding: PostBinding(),
    ),
    GetPage(
      name: AppRoutes.postDetails,
      page: () => const PostDetailView(),
      binding: CommentBinding(),
    ),
  ];
}