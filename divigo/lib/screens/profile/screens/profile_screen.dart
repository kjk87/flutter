import 'dart:developer';
import 'package:divigo/common/utils/loginInfo.dart';
import 'package:divigo/core/localization/app_localization.dart';
import 'package:divigo/screens/home/home_screen.dart';
import 'package:divigo/screens/profile/screens/inquire_screen.dart';
import 'package:divigo/screens/profile/screens/faq_screen.dart';
import 'package:divigo/screens/profile/screens/management_screen.dart';
import 'package:divigo/screens/profile/screens/notice_screen.dart';
import 'package:divigo/screens/profile/screens/notification_screen.dart';
import 'package:divigo/screens/profile/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({super.key});

  @override
  State<ProfileMainScreen> createState() => _ProfileMainScreen();
}

class _ProfileMainScreen extends State<ProfileMainScreen>
    with WidgetsBindingObserver, TabAwareWidget {
  late dynamic user = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    customInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      customInit();
    }
  }

  @override
  void onTabChanged(bool isSelected) {
    log("프로필 탭 상태 변경: ${isSelected ? '선택됨' : '선택 해제됨'}");

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
    log("프로필 탭이 선택되었습니다");
    // 데이터 리로드
    customInit();
  }

  // 탭이 선택 해제되었을 때 실행할 함수
  void _onTabUnselected() {
    log("프로필 탭이 선택 해제되었습니다");
    // 필요한 정리 작업 수행
  }

  customInit() async {
    try {
      final member = await getUser(context);
      log('사용자 정보: $member');

      if (mounted) {
        setState(() {
          user = member;
        });
      }
    } catch (e) {
      log('사용자 정보 로드 오류: $e');
      if (mounted) {
        setState(() {
          user = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 상단 프로필 섹션
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 상단 알림 아이콘
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Color(0xFF6C72CB),
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 프로필 이미지 및 이름
                    GestureDetector(
                      onTap: () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManagementScreen(),
                          ),
                        );
                        if (result != null && !result) {
                          customInit();
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF6C72CB).withOpacity(0.1),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: _getProfileImage(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getNickname(),
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 메뉴 섹션
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 메뉴 카드
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            icon: Icons.help_outline_rounded,
                            title: 'FAQ\'S',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FaqScreen(),
                                ),
                              );
                            },
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.question_answer_outlined,
                            title: AppLocalization.of(context).get('inquire'),
                            onTap: () async {
                              await reloadSession(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InquireScreen(),
                                ),
                              );
                            },
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.campaign_outlined,
                            title: AppLocalization.of(context).get('notice'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NoticeScreen(),
                                ),
                              );
                            },
                          ),
                          _buildDivider(),
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: AppLocalization.of(context).get('setting'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 메뉴 아이템 위젯
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF6C72CB),
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFCCCCCC),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // 구분선 위젯
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        color: Colors.grey.withOpacity(0.1),
        thickness: 1,
        height: 1,
      ),
    );
  }

  // 프로필 이미지를 가져오는 헬퍼 메서드
  Widget _getProfileImage() {
    try {
      if (user == null) {
        return Image.asset(
          'assets/images/ic_profile_default.png',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        );
      }

      // Map 타입인 경우
      if (user is Map) {
        if (user['profile'] == null) {
          return Image.asset(
            'assets/images/ic_profile_default.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          );
        }
        return CachedNetworkImage(
          imageUrl: user['profile'].toString(),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          placeholder: (context, url) => Image.asset(
            'assets/images/ic_profile_default.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/ic_profile_default.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        );
      }

      // Member 클래스 인스턴스인 경우
      if (user.profile == null) {
        return Image.asset(
          'assets/images/ic_profile_default.png',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        );
      }
      return CachedNetworkImage(
        imageUrl: user.profile.toString(),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        placeholder: (context, url) => Image.asset(
          'assets/images/ic_profile_default.png',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/ic_profile_default.png',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      log('프로필 이미지 로드 오류: $e');
      return Image.asset(
        'assets/images/ic_profile_default.png',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }
  }

  // 닉네임을 가져오는 헬퍼 메서드
  String _getNickname() {
    try {
      if (user == null) {
        return '';
      }

      // Map 타입인 경우
      if (user is Map) {
        return user['nickname'] ?? '';
      }

      // Member 클래스 인스턴스인 경우
      return user.nickname ?? '';
    } catch (e) {
      log('닉네임 로드 오류: $e');
      return '';
    }
  }

  // 포인트를 가져오는 헬퍼 메서드
  int _getPoint() {
    try {
      if (user == null) {
        return 0;
      }

      // Map 타입인 경우
      if (user is Map) {
        return user['point'] ?? 0;
      }

      // Member 클래스 인스턴스인 경우
      return user.point ?? 0;
    } catch (e) {
      log('포인트 로드 오류: $e');
      return 0;
    }
  }
}
