import 'package:divigo/common/utils/loginInfo.dart';
import 'package:divigo/screens/profile/screens/notifications_screen.dart';
import 'package:divigo/screens/profile/screens/terms_conditions_screen.dart';
import 'package:divigo/screens/profile/screens/version_screen.dart';
import 'package:divigo/screens/profile/screens/withdrawal_screen.dart';
import 'package:divigo/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:developer';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localization.dart';
import '../../../core/localization/language_constants.dart';
import 'package:divigo/providers/language_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late String version = '';
  late dynamic userData = {};
  bool _isAccountExpanded = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var user = await getUser(context);
    setState(() {
      version = packageInfo.version;
      userData = user;
    });
  }

  // 이메일을 가져오는 헬퍼 메서드
  String _getEmail() {
    try {
      if (userData == null) {
        return '';
      }

      // Map 타입인 경우
      if (userData is Map) {
        return userData['email'] ?? '';
      }

      // Member 클래스 인스턴스인 경우
      return userData.email ?? '';
    } catch (e) {
      log('이메일 로드 오류: $e');
      return '';
    }
  }

  // 가입 타입을 가져오는 헬퍼 메서드
  String _getJoinType() {
    try {
      if (userData == null) {
        return '';
      }

      // Map 타입인 경우
      if (userData is Map) {
        return userData['joinType'] ?? '';
      }

      // Member 클래스 인스턴스인 경우
      return userData.joinType ?? '';
    } catch (e) {
      log('가입 타입 로드 오류: $e');
      return '';
    }
  }

  // 사용자 키를 가져오는 헬퍼 메서드
  String _getUserKey() {
    try {
      if (userData == null) {
        return '';
      }

      // Map 타입인 경우
      if (userData is Map) {
        return userData['userKey'] ?? '';
      }

      // Member 클래스 인스턴스인 경우
      return userData.userKey ?? '';
    } catch (e) {
      log('사용자 키 로드 오류: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          local.get('setting'),
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF333333),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 계정 정보 섹션
                      _buildAccountSection(),
                      const SizedBox(height: 24),

                      // 앱 설정 섹션
                      _buildSettingsSection(),
                    ],
                  ),
                ),
              ),
            ),

            // 로그아웃 버튼
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    final local = AppLocalization.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF6C72CB),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: _isAccountExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isAccountExpanded = expanded;
            });
          },
          title: Text(
            local.get('accountInfo'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          iconColor: const Color(0xFF6C72CB),
          collapsedIconColor: const Color(0xFF999999),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            // 이메일 정보
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    _getEmail(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildLoginTypeIcon(),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 사용자 ID 및 회원 탈퇴
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ID',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _getUserKey(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WithdrawalScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFFF5252),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          local.get('withdrawal'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginTypeIcon() {
    final joinType = _getJoinType();

    if (joinType == 'google') {
      return Image.asset(
        'assets/images/splash_login_google.png',
        width: 20,
        height: 20,
      );
    } else if (joinType == 'apple') {
      return Image.asset(
        'assets/images/splash_login_apple.png',
        width: 20,
        height: 20,
      );
    }

    return const SizedBox();
  }

  Widget _buildSettingsSection() {
    final local = AppLocalization.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          local.get('appSetting'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),

        // 언어 설정
        _buildSettingItem(
          icon: Icons.language_outlined,
          title: local.get('languageSetting'),
          onTap: () => _showLanguageDialog(context),
        ),

        // 이용 약관
        _buildSettingItem(
          icon: Icons.description_outlined,
          title: local.get('termsOfService'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileTermsScreen(),
              ),
            );
          },
        ),

        // 버전 관리
        _buildSettingItem(
          icon: Icons.update_outlined,
          title: local.get('versionManagement'),
          trailing: Text(
            'ver.$version',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6C72CB),
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VersionScreen(),
              ),
            );
          },
        ),

        // 알림 설정
        _buildSettingItem(
          icon: Icons.notifications_outlined,
          title: local.get('notificationSetting'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: const Color(0xFF6C72CB),
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFCCCCCC),
              size: 16,
            ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        minLeadingWidth: 24,
        horizontalTitleGap: 12,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final local = AppLocalization.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          local.get('selectLanguage'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                AppLocalization.of(context).get('korean'),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                ),
              ),
              leading: Radio<Locale>(
                value: koreanLocale,
                groupValue:
                    Provider.of<LanguageProvider>(context).currentLocale,
                activeColor: const Color(0xFF6C72CB),
                onChanged: (Locale? value) {
                  if (value != null) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLocale(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: Text(
                AppLocalization.of(context).get('vietnamese'),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                ),
              ),
              leading: Radio<Locale>(
                value: vietnameseLocale,
                groupValue:
                    Provider.of<LanguageProvider>(context).currentLocale,
                activeColor: const Color(0xFF6C72CB),
                onChanged: (Locale? value) {
                  if (value != null) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLocale(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: Text(
                AppLocalization.of(context).get('english'),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                ),
              ),
              leading: Radio<Locale>(
                value: englishLocale,
                groupValue:
                    Provider.of<LanguageProvider>(context).currentLocale,
                activeColor: const Color(0xFF6C72CB),
                onChanged: (Locale? value) {
                  if (value != null) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLocale(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: Text(
                AppLocalization.of(context).get('thai'),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                ),
              ),
              leading: Radio<Locale>(
                value: thaiLocale,
                groupValue:
                    Provider.of<LanguageProvider>(context).currentLocale,
                activeColor: const Color(0xFF6C72CB),
                onChanged: (Locale? value) {
                  if (value != null) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLocale(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: Text(
                AppLocalization.of(context).get('maley'),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF333333),
                ),
              ),
              leading: Radio<Locale>(
                value: maleyLocale,
                groupValue:
                    Provider.of<LanguageProvider>(context).currentLocale,
                activeColor: const Color(0xFF6C72CB),
                onChanged: (Locale? value) {
                  if (value != null) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLocale(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    final local = AppLocalization.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: const Color(0xFF666666),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(local.get('logout')),
      ),
    );
  }

  Future<void> _logout() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
      (route) => false,
    );
  }
}
