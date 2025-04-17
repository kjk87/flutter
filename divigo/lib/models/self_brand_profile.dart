import 'package:divigo/models/self_brand_post.dart';

class SelfBrandProfile {
  final String id;
  final String moveNumber;
  final String phoneNumber;
  final String title;
  final String backgroundImage;
  final String description;
  final String telegramUrl;
  final String xUrl;
  final String youtubeUrl;
  final String homepageUrl;
  final List<SelfBrandPost> posts;

  SelfBrandProfile({
    required this.id,
    required this.moveNumber,
    required this.phoneNumber,
    required this.title,
    required this.backgroundImage,
    required this.description,
    required this.telegramUrl,
    required this.xUrl,
    required this.youtubeUrl,
    required this.homepageUrl,
    required this.posts,
  });
}
