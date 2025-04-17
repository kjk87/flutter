class Games {
  int id;
  String name;
  String image;
  String url;
  String orientation;
  String announce_date;
  int period;
  bool is_ranking;
  String prize_type;
  int prize_1;
  int prize_2;
  int prize_3;
  int prize_other;
  int cut_off_score;
  GameRanking? ranking;

  Games({
    required this.id,
    required this.name,
    required this.image,
    required this.url,
    required this.orientation,
    required this.announce_date,
    required this.period,
    required this.is_ranking,
    required this.prize_type,
    required this.prize_1,
    required this.prize_2,
    required this.prize_3,
    required this.prize_other,
    required this.cut_off_score,
    this.ranking,
  });

  // JSON 데이터로부터 Games 객체 생성
  factory Games.fromJson(Map<String, dynamic> json) {
    return Games(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      url: json['url'] as String,
      orientation: json['orientation'] as String,
      announce_date: json['announce_date'] as String,
      period: json['period'] as int,
      is_ranking: json['is_ranking'] as bool,
      prize_type: json['prize_type'] as String,
      prize_1: json['prize_1'] as int,
      prize_2: json['prize_2'] as int,
      prize_3: json['prize_3'] as int,
      prize_other: json['prize_other'] as int,
      cut_off_score: json['cut_off_score'] as int,
      ranking: json['ranking'] != null
          ? GameRanking.fromJson(json['ranking'] as Map<String, dynamic>)
          : null,
    );
  }

  // Games 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'url': url,
      'orientation': orientation,
      'announce_date': announce_date,
      'period': period,
      'is_ranking': is_ranking,
      'prize_type': prize_type,
      'prize_1': prize_1,
      'prize_2': prize_2,
      'prize_3': prize_3,
      'prize_other': prize_other,
      'cut_off_score': cut_off_score,
      'ranking': ranking?.toJson(),
    };
  }
}

class GameRanking {
  final int id;
  final String? type;
  final String userKey;
  final int? gamesId;
  final int? bestScore;
  final String? createdAt;
  final String? updatedAt;
  int? ranking;

  GameRanking({
    required this.id,
    this.type,
    required this.userKey,
    this.gamesId,
    this.bestScore,
    this.createdAt,
    this.updatedAt,
    this.ranking,
  });

  // JSON에서 객체 생성
  factory GameRanking.fromJson(Map<String, dynamic> json) {
    return GameRanking(
      id: json['id'] as int,
      type: json['type'] as String?,
      userKey: json['userKey'] as String,
      gamesId: json['gamesId'] as int?,
      bestScore: json['bestScore'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      ranking: json['ranking'] as int?,
    );
  }

  // 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (userKey != null) 'userKey': userKey,
      if (gamesId != null) 'gamesId': gamesId,
      if (bestScore != null) 'bestScore': bestScore,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (ranking != null) 'ranking': ranking,
    };
  }

  // 객체 복사본 생성 with 수정된 필드
  GameRanking copyWith({
    int? id,
    String? type,
    int? telegramUserId,
    String? userKey,
    int? gamesId,
    int? bestScore,
    String? createdAt,
    String? updatedAt,
    int? ranking,
  }) {
    return GameRanking(
      id: id ?? this.id,
      type: type ?? this.type,
      userKey: userKey ?? this.userKey,
      gamesId: gamesId ?? this.gamesId,
      bestScore: bestScore ?? this.bestScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ranking: ranking ?? this.ranking,
    );
  }
}
