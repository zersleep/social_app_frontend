class PostModel {
  final String id;
  final String username;
  final String profileImage;
  final String subtitle;
  final List<String> images;
  final String caption;
  final int likeCount;
  final int commentCount;
  final String timeAgo;
  final bool hasStory;

  const PostModel({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.subtitle,
    required this.images,
    required this.caption,
    this.likeCount   = 0,
    this.commentCount = 0,
    this.timeAgo     = '',
    this.hasStory    = false,
  });
}
