class DailyTasks {
  final int? id;
  final String? name;
  final String? description;
  final int? requiredLoginStreak;
  final int? rewardCoins;
  final String? createdAt;
  final String? updatedAt;
  final int? available;
  final int? completed;

  DailyTasks({
    this.id,
    this.name,
    this.description,
    this.requiredLoginStreak,
    this.rewardCoins,
    this.createdAt,
    this.updatedAt,
    this.available,
    this.completed,
  });

  // JSON에서 객체 생성
  factory DailyTasks.fromJson(Map<String, dynamic> json) {
    return DailyTasks(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      requiredLoginStreak: json['requiredLoginStreak'] as int?,
      rewardCoins: json['rewardCoins'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      available: json['available'] as int?,
      completed: json['completed'] as int?,
    );
  }

  // 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (requiredLoginStreak != null) 'requiredLoginStreak': requiredLoginStreak,
      if (rewardCoins != null) 'rewardCoins': rewardCoins,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (available != null) 'available': available,
      if (completed != null) 'completed': completed,
    };
  }

  // 객체 복사본 생성 with 수정된 필드
  DailyTasks copyWith({
    int? id,
    String? name,
    String? description,
    int? requiredLoginStreak,
    int? rewardCoins,
    String? createdAt,
    String? updatedAt,
  }) {
    return DailyTasks(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      requiredLoginStreak: requiredLoginStreak ?? this.requiredLoginStreak,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}