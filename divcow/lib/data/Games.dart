class Games{
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

//<editor-fold desc="Data Methods">
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
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Games &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              image == other.image &&
              url == other.url &&
              orientation == other.orientation &&
              announce_date == other.announce_date &&
              period == other.period &&
              is_ranking == other.is_ranking &&
              prize_type == other.prize_type &&
              prize_1 == other.prize_1 &&
              prize_2 == other.prize_2 &&
              prize_3 == other.prize_3 &&
              prize_other == other.prize_other
          );

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      url.hashCode ^
      orientation.hashCode ^
      announce_date.hashCode ^
      period.hashCode ^
      is_ranking.hashCode ^
      prize_type.hashCode ^
      prize_1.hashCode ^
      prize_2.hashCode ^
      prize_3.hashCode ^
      prize_other.hashCode;

  @override
  String toString() {
    return 'Games{' +
        ' id: $id,' +
        ' name: $name,' +
        ' image: $image,' +
        ' url: $url,' +
        ' orientation: $orientation,' +
        ' announce_date: $announce_date,' +
        ' period: $period,' +
        ' is_ranking: $is_ranking,' +
        ' prize_type: $prize_type,' +
        ' prize_1: $prize_1,' +
        ' prize_2: $prize_2,' +
        ' prize_3: $prize_3,' +
        ' prize_other: $prize_other,' +
        '}';
  }

  Games copyWith({
    int? id,
    String? name,
    String? image,
    String? url,
    String? orientation,
    String? announce_date,
    int? period,
    bool? is_ranking,
    String? prize_type,
    int? prize_1,
    int? prize_2,
    int? prize_3,
    int? prize_other,
  }) {
    return Games(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      url: url ?? this.url,
      orientation: orientation ?? this.orientation,
      announce_date: announce_date ?? this.announce_date,
      period: period ?? this.period,
      is_ranking: is_ranking ?? this.is_ranking,
      prize_type: prize_type ?? this.prize_type,
      prize_1: prize_1 ?? this.prize_1,
      prize_2: prize_2 ?? this.prize_2,
      prize_3: prize_3 ?? this.prize_3,
      prize_other: prize_other ?? this.prize_other,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'url': this.url,
      'orientation': this.orientation,
      'announce_date': this.announce_date,
      'period': this.period,
      'is_ranking': this.is_ranking,
      'prize_type': this.prize_type,
      'prize_1': this.prize_1,
      'prize_2': this.prize_2,
      'prize_3': this.prize_3,
      'prize_other': this.prize_other,
    };
  }

  factory Games.fromMap(Map<String, dynamic> map) {
    return Games(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      url: map['url'] as String,
      orientation: map['orientation'] as String,
      announce_date: map['announce_date'] as String,
      period: map['period'] as int,
      is_ranking: map['is_ranking'] as bool,
      prize_type: map['prize_type'] as String,
      prize_1: map['prize_1'] as int,
      prize_2: map['prize_2'] as int,
      prize_3: map['prize_3'] as int,
      prize_other: map['prize_other'] as int,
    );
  }

//</editor-fold>
}