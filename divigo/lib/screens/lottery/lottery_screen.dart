import 'dart:developer';

import 'package:divigo/common/utils/admobUtil.dart';
import 'package:divigo/core/localization/app_localization.dart';
import 'package:divigo/screens/lottery/lottery_guide_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:divigo/screens/lottery/scratch_lottery_screen.dart';
import 'package:divigo/common/utils/loginInfo.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/screens/home/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LotteryWinner {
  final String username;
  final int amount;
  final String reply;
  final String time;
  final String profile;
  final int? rank;

  LotteryWinner({
    required this.username,
    required this.amount,
    required this.reply,
    required this.time,
    required this.profile,
    this.rank,
  });

  factory LotteryWinner.fromJson(Map<String, dynamic> json) {
    return LotteryWinner(
      username: json['nickname'] ?? 'Anonymous',
      amount: json['amount'] ?? 0,
      reply: json['reply'] ?? 'Congratulations!',
      time: json['time'] ?? '00:00',
      profile: json['profile'] ?? '',
      rank: json['rank'],
    );
  }
}

class LotteryScreen extends StatefulWidget {
  const LotteryScreen({super.key});

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen>
    with WidgetsBindingObserver, TabAwareWidget {
  int lotteryCount = 0;
  bool isLoading = true;
  List<LotteryWinner> winners = [];
  bool isLoadingWinners = true;
  int totalWinners = 0;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
    _loadWinnersList();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadUserData();
      _loadWinnersList();
      _loadAdData();
    }
  }

  @override
  void onTabChanged(bool isSelected) {
    log("복권 탭 상태 변경: ${isSelected ? '선택됨' : '선택 해제됨'}");

    if (isSelected) {
      // 탭이 선택되었을 때 실행할 함수
      _onTabSelected();
    } else {
      // 탭이 선택 해제되었을 때 실행할 함수
      _onTabUnselected();
    }
  }

  // 탭이 선택되었을 때 실행할 함수
  void _onTabSelected() {
    log("복권 탭이 선택되었습니다");
    // 데이터 리로드
    _loadUserData();
    _loadWinnersList();
    _loadAdData();
    // 기타 필요한 작업 수행
    _performOtherTasks();
  }

  // 탭이 선택 해제되었을 때 실행할 함수
  void _onTabUnselected() {
    log("복권 탭이 선택 해제되었습니다");
    // 필요한 정리 작업 수행
  }

  // 기타 필요한 작업을 수행하는 함수
  void _performOtherTasks() {
    // 예: 애니메이션 시작, 데이터 갱신 등
    log("기타 작업 수행 중");
  }

  // 어제 날짜를 YYYY-MM-DD 형식으로 반환하는 함수
  String _getYesterdayDate() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return DateFormat('yyyy-MM-dd').format(yesterday);
  }

  // 당첨자 목록을 불러오는 함수
  Future<void> _loadWinnersList() async {
    if (!mounted) return;

    log("당첨자 목록 로딩 시작");
    setState(() {
      isLoadingWinners = true;
    });

    final response = await httpGetWithCode(
      path: '/lotteryWinner',
      queryParameters: {'date': _getYesterdayDate()},
    );

    log(response.toString());
    log("당첨자 목록 로드 성공: ${response['list']?.length ?? 0}명 / 총 ${response['total'] ?? 0}명");

    final List<LotteryWinner> loadedWinners = [];
    if (response['list'] is List) {
      for (var item in response['list']) {
        if (item is Map<String, dynamic>) {
          loadedWinners.add(LotteryWinner.fromJson(item));
        }
      }
    }

    setState(() {
      winners = loadedWinners;
      totalWinners = response['total'] ?? 0;
      isLoadingWinners = false;
    });
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    log("복권 데이터 로딩 시작");

    setState(() {
      isLoading = true;
    });

    final user = await getUser(context);
    if (user != null && mounted) {
      log("사용자 데이터 로드 성공: ${user.lotteryCount}");
      setState(() {
        lotteryCount = user.lotteryCount;
        isLoading = false;
      });
    } else if (mounted) {
      log("사용자 데이터 로드 실패");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadAdData() async {
    AdmobUtil.instance.createLotteryInterstitialAd(cb: () {
      setState(() {
        isAdLoaded = true;
      });
    });
  }

  // 등수별 색상을 반환하는 함수
  Color _getRankColor(int? rank) {
    switch (rank ?? 0) {
      case 1:
        return Color(0xFFFFD700); // 금색
      case 2:
        return Color(0xFFC0C0C0); // 은색
      case 3:
        return Color(0xFFCD7F32); // 동색
      default:
        return Color(0xFF6C72CB); // 기본 색상
    }
  }

  // 등수별 아이콘을 반환하는 함수
  Widget _getRankIcon(int? rank) {
    switch (rank ?? 0) {
      case 1:
        return Icon(Icons.emoji_events, color: Colors.white, size: 12);
      case 2:
        return Icon(Icons.emoji_events, color: Colors.white, size: 12);
      case 3:
        return Icon(Icons.emoji_events, color: Colors.white, size: 12);
      default:
        return Text(
          '${rank ?? 0}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTickets = lotteryCount > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).get('lottery')),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LotteryGuideScreen(),
              ),
            ).then((_) => _loadUserData()),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Image.asset(
                          'assets/images/ic_lottery.png',
                          width: 80,
                          height: 80,
                        ),
                        Text(
                          AppLocalization.of(context)
                              .get('myLottery')
                              .replaceAll(
                                  '%s', '${hasTickets ? lotteryCount : "0"}'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Color(0xFF6C72CB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            AppLocalization.of(context)
                                .get('yesterdayWinnerReview'),
                            style: TextStyle(
                              color: Color(0xFF6C72CB),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        isLoadingWinners
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : winners.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Text(
                                        AppLocalization.of(context)
                                            .get('notExistYesterdayWinner'),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: winners.length,
                                    itemBuilder: (context, index) => Container(
                                      margin: EdgeInsets.only(bottom: 16),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundColor:
                                                    Color(0xFF6C72CB)
                                                        .withOpacity(0.1),
                                                backgroundImage: winners[index]
                                                        .profile
                                                        .isNotEmpty
                                                    ? NetworkImage(
                                                        winners[index].profile)
                                                    : null,
                                                child: winners[index]
                                                        .profile
                                                        .isEmpty
                                                    ? Text(
                                                        winners[index]
                                                                .username
                                                                .isNotEmpty
                                                            ? winners[index]
                                                                .username[0]
                                                                .toUpperCase()
                                                            : 'U',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF6C72CB),
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              if (winners[index].rank != null &&
                                                  winners[index].rank! > 0 &&
                                                  winners[index].rank! <= 3)
                                                Positioned(
                                                  right: -4,
                                                  bottom: -4,
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: _getRankColor(
                                                          winners[index].rank),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.5),
                                                    ),
                                                    child: _getRankIcon(
                                                        winners[index].rank),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      winners[index].username,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      '${winners[index].amount}P',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF6C72CB),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    if (winners[index].rank! <
                                                        4)
                                                      Text(
                                                        '(\$${(winners[index].amount / 10000).toStringAsFixed(0)})',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    if (winners[index].rank !=
                                                        null)
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 8),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 6,
                                                                vertical: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _getRankColor(
                                                                  winners[index]
                                                                      .rank)
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Text(
                                                          '${winners[index].rank}th',
                                                          style: TextStyle(
                                                            color: _getRankColor(
                                                                winners[index]
                                                                    .rank),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  winners[index].reply,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            winners[index].time,
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!hasTickets)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            AppLocalization.of(context).get('notExistLottery'),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      if (hasTickets && isAdLoaded)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline, // 정보 아이콘(느낌표 동그라미)
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4), // 아이콘과 텍스트 사이 간격
                              Text(
                                AppLocalization.of(context)
                                    .get('scratchLotteryDesc'),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: hasTickets
                              ? () {
                                  if (isAdLoaded) {
                                    AdmobUtil.instance
                                        .showLotteryInterstitialAd(cb: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ScratchLotteryScreen(),
                                        ),
                                      ).then((_) => _loadUserData());
                                    });
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6C72CB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: !isAdLoaded
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '로딩중',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 24,
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.ballPulse,
                                        colors: [Colors.white],
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  AppLocalization.of(context)
                                      .get('scratchLottery'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
