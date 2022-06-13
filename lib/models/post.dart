import 'package:flutter_blog_app/models/user.dart';

// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

class Post {
  String? body;
  String? image;
  int? id;
  int? likesCount;
  int? commentsCount;
  bool? selfLiked;
  User? user;

  Post({
    this.body,
    this.image,
    this.id,
    this.likesCount,
    this.commentsCount,
    this.selfLiked,
    this.user,
  });


  // factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    body: json["body"],
    image: json["image"],
    id: json["id"],
    likesCount: json["likes_count"],
    commentsCount: json["comments_count"],
    selfLiked: json["likes"].length > 0,
    user: User(
      id: json['user']['id'],
      name: json['user']['name'],
      image: json['user']['image']
    )
  );

  Map<String, dynamic> toJson() => {
    "body": body,
    "image": image,
    "id": id,
    "likesCount": likesCount,
    "commentsCount": commentsCount,
    "selfLiked": selfLiked,
  };
}
