class HistoryPoint {
  final int seqNo;
  final String userKey;
  final String category;
  final String type;
  final double point;
  final String subject;
  final String comment;
  final String regDatetime;

  HistoryPoint({
    required this.seqNo,
    required this.userKey,
    required this.category,
    required this.type,
    required this.point,
    required this.subject,
    required this.comment,
    required this.regDatetime,
  });

  // JSON으로부터 모델 객체 생성
  factory HistoryPoint.fromJson(Map<String, dynamic> json) {
    return HistoryPoint(
      seqNo: json['seqNo'] as int,
      userKey: json['userKey'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
      point: (json['point'] is int)
          ? (json['point'] as int).toDouble()
          : json['point'] as double,
      subject: json['subject'] as String,
      comment: json['comment'] as String,
      regDatetime: json['regDatetime'] as String,
    );
  }

  // 모델 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'seqNo': seqNo,
      'userKey': userKey,
      'category': category,
      'type': type,
      'point': point,
      'subject': subject,
      'comment': comment,
      'regDatetime': regDatetime,
    };
  }

  // 객체 복사본 생성 (수정 시 유용)
  HistoryPoint copyWith({
    int? seqNo,
    String? userKey,
    String? category,
    String? type,
    double? point,
    String? subject,
    String? comment,
    String? regDatetime,
  }) {
    return HistoryPoint(
      seqNo: seqNo ?? this.seqNo,
      userKey: userKey ?? this.userKey,
      category: category ?? this.category,
      type: type ?? this.type,
      point: point ?? this.point,
      subject: subject ?? this.subject,
      comment: comment ?? this.comment,
      regDatetime: regDatetime ?? this.regDatetime,
    );
  }

  @override
  String toString() {
    return 'HistoryPoint{seqNo: $seqNo, userKey: $userKey, category: $category, type: $type, point: $point, subject: $subject, comment: $comment, regDatetime: $regDatetime}';
  }
}