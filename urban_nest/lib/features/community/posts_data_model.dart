class CommunityPost {
  final String profileImage;
  final String name;
  final bool isVerified;
  final String time;
  final String content;
  final String category; // News, Events, Discussions, Alerts
  final int likes;
  final int comments;
  final int shares;
  final int views;

  CommunityPost({
    required this.profileImage,
    required this.name,
    required this.isVerified,
    required this.time,
    required this.content,
    required this.category,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.views,
  });
}
