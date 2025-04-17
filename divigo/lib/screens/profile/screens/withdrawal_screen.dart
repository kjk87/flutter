import 'package:divigo/common/utils/http.dart';
import 'package:divigo/common/utils/loginInfo.dart';
import 'package:divigo/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:divigo/core/localization/app_localization.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  late dynamic userData = {};
  late bool confirm = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    try {
      var user = await getUser(context);
      setState(() {
        userData = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(AppLocalization.of(context).get('userInfoLoadError'));
    }
  }

  clickWithdrawal(bool click) async {
    if (click) {
      setState(() {
        isLoading = true;
      });

      try {
        await httpPost(path: '/member/withdrawal');
        const storage = FlutterSecureStorage();
        await storage.deleteAll();

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      } catch (e) {
        setState(() {
          isLoading = false;
          confirm = false;
        });
        _showErrorDialog(AppLocalization.of(context).get('withdrawalError'));
      }
    } else {
      setState(() {
        confirm = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).get('withdrawal'),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C72CB)),
              ),
            )
          : Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalization.of(context).get('withdrawal'),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 중요 공지 카드
                              _buildInfoCard(
                                title: AppLocalization.of(context)
                                    .get('importantNotice'),
                                content: AppLocalization.of(context)
                                    .get('importantNoticeDesc'),
                                isWarning: true,
                              ),
                              const SizedBox(height: 16),

                              // 보유 포인트 카드
                              _buildPointCard(),
                              const SizedBox(height: 16),

                              // 회원 탈퇴 방법 카드
                              _buildInfoCard(
                                title: AppLocalization.of(context)
                                    .get('withdrawalMethod'),
                                content: AppLocalization.of(context)
                                    .get('withdrawalMethodDetail'),
                                isWarning: false,
                              ),
                              const SizedBox(height: 16),

                              // 회원 탈퇴 기간 카드
                              _buildInfoCard(
                                title: AppLocalization.of(context)
                                    .get('withdrawalPeriod'),
                                content: AppLocalization.of(context)
                                    .get('withdrawDescription'),
                                isWarning: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildWithdrawalButton(),
                    ],
                  ),
                ),
                // 확인 다이얼로그
                confirm
                    ? Container(
                        color: const Color.fromRGBO(0, 0, 0, 0.4),
                        child: Center(
                          child: _buildConfirmDialog(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required bool isWarning,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isWarning
              ? const Color(0xFFFF5D5D).withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      color:
          isWarning ? const Color(0xFFFF5D5D).withOpacity(0.05) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isWarning ? Icons.warning_amber : Icons.info_outline,
                  size: 18,
                  color: isWarning
                      ? const Color(0xFFFF5D5D)
                      : const Color(0xFF6C72CB),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isWarning
                        ? const Color(0xFFFF5D5D)
                        : const Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: isWarning
                    ? const Color(0xFFFF5D5D).withOpacity(0.8)
                    : const Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalization.of(context).get('point'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),

            // 포인트 정보
            Row(
              children: [
                Text(
                  AppLocalization.of(context).get('point'),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                const Spacer(),
                Text(
                  userData is Map
                      ? (userData['point'] ?? '0').toString()
                      : (userData.point ?? '0').toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/profile_withdrawal_point.png',
                  width: 20,
                ),
              ],
            ),
            // const SizedBox(height: 12),
            //
            // // TETHER 정보
            // Row(
            //   children: [
            //     Text(
            //       AppLocalization.of(context).get('tether'),
            //       style: const TextStyle(
            //         fontSize: 14,
            //         color: Color(0xFF666666),
            //       ),
            //     ),
            //     const Spacer(),
            //     Text(
            //       userData is Map
            //           ? (userData['tether'] ?? '0').toString()
            //           : (userData.tether ?? '0').toString(),
            //       style: const TextStyle(
            //         fontSize: 14,
            //         color: Color(0xFF333333),
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     const SizedBox(width: 8),
            //     Image.asset(
            //       'assets/images/profile_tether.png',
            //       width: 20,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawalButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            confirm = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5D5D),
          foregroundColor: Colors.white,
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
        child: Text(AppLocalization.of(context).get('withdrawalRequest')),
      ),
    );
  }

  Widget _buildConfirmDialog() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber,
              color: Color(0xFFFF5D5D),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalization.of(context).get('withdrawalConfirm'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalization.of(context).get('withdrawalConfirmDetail'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => clickWithdrawal(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF666666),
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(AppLocalization.of(context).get('cancel')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => clickWithdrawal(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5D5D),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(AppLocalization.of(context).get('withdrawal')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            AppLocalization.of(context).get('error'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6C72CB),
              ),
              child: Text(AppLocalization.of(context).get('confirm')),
            ),
          ],
        );
      },
    );
  }
}
