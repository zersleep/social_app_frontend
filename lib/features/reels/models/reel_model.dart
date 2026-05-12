class ReelModel {
  final String id;
  final String videoPath;
  final String username;
  final String profileImage;
  final String caption;
  final String audioTitle;
  final int    likeCount;
  final int    commentCount;
  final int    shareCount;
  final bool   isFollowing;

  const ReelModel({
    required this.id,
    required this.videoPath,
    required this.username,
    required this.profileImage,
    required this.caption,
    this.audioTitle   = 'Original audio',
    this.likeCount    = 0,
    this.commentCount = 0,
    this.shareCount   = 0,
    this.isFollowing  = false,
  });
}
