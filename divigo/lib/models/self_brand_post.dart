class SelfBrandPost {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;

  SelfBrandPost({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });
}
