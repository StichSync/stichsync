class CrochetModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String description;
  final String mediaUrl;
  final int upvoteCount;
  final int downvoteCount;
  final int saveCount;
  final String authorNickname;

  CrochetModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.description,
    required this.mediaUrl,
    required this.upvoteCount,
    required this.downvoteCount,
    required this.saveCount,
    required this.authorNickname,
  });
}
