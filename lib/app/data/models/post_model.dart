import 'user_model.dart';
import 'comment_model.dart';

class PostModel {
  final int? id;
  final String? title;
  final String? image;
  final int? userId;
  final String? createdAt;
  final UserModel? user;
  final List<CommentModel> comments;

  PostModel({
    this.id,
    this.title,
    this.image,
    this.userId,
    this.createdAt,
    this.user,
    this.comments = const [],
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
      comments: json['comments'] != null
          ? (json['comments'] as List)
              .map((comment) => CommentModel.fromJson(comment))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'user_id': userId,
      'created_at': createdAt,
      'user': user?.toJson(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}