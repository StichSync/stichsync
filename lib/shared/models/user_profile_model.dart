import 'package:stichsync/views/home/inspirations/components/inspiration_post.dart';

class UserProfileModel {
  late String email;
  late String? picUrl;
  late String? username;
  late List<InspirationPost> posts;

  UserProfileModel({
    required this.email,
    this.picUrl,
    this.username,
    List<InspirationPost>? posts,
  }) : posts = posts ?? [];
}
