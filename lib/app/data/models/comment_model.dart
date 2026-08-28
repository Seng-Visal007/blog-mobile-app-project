import 'user_model.dart';

class CommentModel {
  final int? id;
  final String? content;
  final int? userId;
  final int? postId;
  final String? createdAt;
  final UserModel? user;

  CommentModel({
    this.id,
    this.content,
    this.userId,
    this.postId,
    this.createdAt,
    this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'],
      userId: json['user_id'],
      postId: json['post_id'],
      createdAt: json['created_at'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt,
      'user': user?.toJson(),
    };
  }
}