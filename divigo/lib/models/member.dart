class Member {
  final String userKey;
  final String nation;
  final String language;
  final String nickname;
  final String status; // active, dormancy, stop, leave, waitingLeave
  final String joinType; // google, apple
  final String joinPlatform; // aos, ios, window
  final DateTime joinDatetime;
  final String? recommendeeKey;
  final String? email;
  final String device;
  final String? gender;
  final String? birthday;
  final String? profile;
  final String? platformEmail; // 회원가입시 업체로부터 내려받은 이메일
  final String platformKey; // 회원가입시 업체로부터 내려받은 아이디
  final DateTime? lastLoginDatetime;
  final DateTime? leaveRequestDatetime;
  final DateTime? leaveFinishDatetime;
  final String? leaveMsg;
  final DateTime? modDatetime;
  final double point; // decimal(15,3)
  final double ton;
  final double tether;
  final String? inviteUrl;
  final int invitePoint;
  final int attendanceCount;
  final DateTime? attendanceDate;
  final int inviteCount;
  final String? wallet;
  final int loginStreak;
  final int lotteryCount;

  Member({
    required this.userKey,
    required this.nation,
    required this.language,
    required this.nickname,
    required this.status,
    required this.joinType,
    required this.joinPlatform,
    required this.joinDatetime,
    this.recommendeeKey,
    this.email,
    required this.device,
    this.gender,
    this.birthday,
    this.profile,
    this.platformEmail,
    required this.platformKey,
    this.lastLoginDatetime,
    this.leaveRequestDatetime,
    this.leaveFinishDatetime,
    this.leaveMsg,
    this.modDatetime,
    required this.point,
    required this.ton,
    required this.tether,
    this.inviteUrl,
    required this.invitePoint,
    required this.attendanceCount,
    this.attendanceDate,
    required this.inviteCount,
    this.wallet,
    required this.loginStreak,
    required this.lotteryCount,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      userKey: json['userKey'] as String,
      nation: json['nation'] as String,
      language: json['language'] as String,
      nickname: json['nickname'] as String,
      status: json['status'] as String,
      joinType: json['joinType'] as String,
      joinPlatform: json['joinPlatform'] as String,
      joinDatetime: DateTime.parse(json['joinDatetime'] as String),
      recommendeeKey: json['recommendeeKey'] as String?,
      email: json['email'] as String?,
      device: json['device'] as String,
      gender: json['gender'] as String?,
      birthday: json['birthday'] as String?,
      profile: json['profile'] as String?,
      platformEmail: json['platformEmail'] as String?,
      platformKey: json['platformKey'] as String,
      lastLoginDatetime: json['lastLoginDatetime'] != null
          ? DateTime.parse(json['lastLoginDatetime'] as String)
          : null,
      leaveRequestDatetime: json['leaveRequestDatetime'] != null
          ? DateTime.parse(json['leaveRequestDatetime'] as String)
          : null,
      leaveFinishDatetime: json['leaveFinishDatetime'] != null
          ? DateTime.parse(json['leaveFinishDatetime'] as String)
          : null,
      leaveMsg: json['leaveMsg'] as String?,
      modDatetime: json['modDatetime'] != null
          ? DateTime.parse(json['modDatetime'] as String)
          : null,
      point: (json['point'] as num).toDouble(),
      ton: (json['ton'] as num).toDouble(),
      tether: (json['tether'] as num).toDouble(),
      inviteUrl: json['inviteUrl'] as String?,
      invitePoint: json['invitePoint'] as int? ?? 0,
      attendanceCount: json['attendanceCount'] as int? ?? 0,
      attendanceDate: json['attendanceDate'] != null
          ? DateTime.parse(json['attendanceDate'] as String)
          : null,
      inviteCount: json['inviteCount'] as int? ?? 0,
      wallet: json['wallet'] as String?,
      loginStreak: json['loginStreak'] as int? ?? 0,
      lotteryCount: json['lotteryCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userKey': userKey,
      'nation': nation,
      'language': language,
      'nickname': nickname,
      'status': status,
      'joinType': joinType,
      'joinPlatform': joinPlatform,
      'joinDatetime': joinDatetime.toIso8601String(),
      'recommendeeKey': recommendeeKey,
      'email': email,
      'device': device,
      'gender': gender,
      'birthday': birthday,
      'profile': profile,
      'platformEmail': platformEmail,
      'platformKey': platformKey,
      'lastLoginDatetime': lastLoginDatetime?.toIso8601String(),
      'leaveRequestDatetime': leaveRequestDatetime?.toIso8601String(),
      'leaveFinishDatetime': leaveFinishDatetime?.toIso8601String(),
      'leaveMsg': leaveMsg,
      'modDatetime': modDatetime?.toIso8601String(),
      'point': point,
      'ton': ton,
      'tether': tether,
      'inviteUrl': inviteUrl,
      'invitePoint': invitePoint,
      'attendanceCount': attendanceCount,
      'attendanceDate': attendanceDate?.toIso8601String(),
      'inviteCount': inviteCount,
      'wallet': wallet,
      'loginStreak': loginStreak,
      'lotteryCount': lotteryCount,
    };
  }
}
