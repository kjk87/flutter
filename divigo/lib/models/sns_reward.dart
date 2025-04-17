class SnsReward {
  final String userKey;
  final bool? youtube;
  final bool? telegram;
  final bool? discord;
  final bool? x;
  final bool? instagram;

  SnsReward({
    required this.userKey,
    this.youtube,
    this.telegram,
    this.discord,
    this.x,
    this.instagram,
  });

  factory SnsReward.fromJson(Map<String, dynamic> json) {
    return SnsReward(
      userKey: json['userKey'],
      youtube: json['youtube'],
      telegram: json['telegram'],
      discord: json['discord'],
      x: json['x'],
      instagram: json['instagram'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userKey': userKey,
      'youtube': youtube,
      'telegram': telegram,
      'discord': discord,
      'x': x,
      'instagram': instagram,
    };
  }
}