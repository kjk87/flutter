class Vesting {
  final String key;
  final String name;
  final String token;
  final String recipient;
  final DateTime createdAt;
  final String depositedAmount;
  final String withdrawnAmount;
  final DateTime lastWithdrawnAt;
  final DateTime start;
  final int period;
  final DateTime cliff;
  final String cliffAmount;
  final String amountPerPeriod;

  Vesting({
    required this.key,
    required this.name,
    required this.token,
    required this.recipient,
    required this.createdAt,
    required this.depositedAmount,
    required this.withdrawnAmount,
    required this.lastWithdrawnAt,
    required this.start,
    required this.period,
    required this.cliff,
    required this.cliffAmount,
    required this.amountPerPeriod,
  });

  factory Vesting.fromJson(Map<String, dynamic> json) {
    return Vesting(
      key: json['key'],
      name: json['name'],
      token: json['token'],
      recipient: json['recipient'],
      createdAt: DateTime.parse(json['createdAt']),
      depositedAmount: json['depositedAmount'],
      withdrawnAmount: json['withdrawnAmount'],
      lastWithdrawnAt: DateTime.parse(json['lastWithdrawnAt']),
      start: DateTime.parse(json['start']),
      period: json['period'],
      cliff: DateTime.parse(json['cliff']),
      cliffAmount: json['cliffAmount'],
      amountPerPeriod: json['amountPerPeriod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'token': token,
      'recipient': recipient,
      'createdAt': createdAt.toIso8601String(),
      'depositedAmount': depositedAmount,
      'withdrawnAmount': withdrawnAmount,
      'lastWithdrawnAt': lastWithdrawnAt.toIso8601String(),
      'start': start.toIso8601String(),
      'period': period,
      'cliff': cliff.toIso8601String(),
      'cliffAmount': cliffAmount,
      'amountPerPeriod': amountPerPeriod,
    };
  }
}