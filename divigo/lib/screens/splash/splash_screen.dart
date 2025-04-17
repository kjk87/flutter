import 'dart:developer';
import 'dart:io';

import 'package:divigo/common/utils/http.dart';
import 'package:divigo/common/utils/session.dart';
import 'package:divigo/core/localization/app_localization.dart';
import 'package:divigo/screens/home/home_screen.dart';
import 'package:divigo/widgets/signin/signInApp.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late bool isLogin = false;
  late bool isDemo = false;

  @override
  void initState() {
    super.initState();
    customInit();
  }

  void customInit() async {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    await _controller.forward();
    loginCheck();
    if (Platform.isAndroid) {
      demoCheck();
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  loginCheck() async {
    bool chk = await sessionCheck();
    if (chk) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      setState(() {
        isLogin = true;
      });
    }
  }

  demoCheck() async {
    // String url = '/config/demoLogin';
    // if (Platform.isIOS) {
    //   url = '/config/demoLoginIos';
    // }
    var config = await httpGetWithCode(path: '/config/demoLogin');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    log(config.toString());
    log(packageInfo.version);
    if (config['config'] == packageInfo.version) {
      setState(() {
        isDemo = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Stack(
          children: [
            // 배경 패턴
            ...List.generate(
              20,
              (index) => Positioned(
                left: index * 50.0,
                top: index * 50.0,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // 메인 콘텐츠
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 로고 아이콘
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/icon.png',
                              width: 120,
                              height: 120,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // 앱 이름
                          const Text(
                            'DIV',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Digital Identity Value',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 48),
                          // 로딩 인디케이터
                          SizedBox(
                            width: 40,
                            height: 40,
                            // child: CircularProgressIndicator(
                            //   valueColor: AlwaysStoppedAnimation<Color>(
                            //     Colors.white.withOpacity(0.8),
                            //   ),
                            //   strokeWidth: 3,
                            // ),
                          ),
                          const SizedBox(height: 48),
                          if (isLogin)
                            // 구글 로그인 버튼
                            GestureDetector(
                              onTap: () async {
                                var res = await signInApp(context, 'google');

                                if (res?['code'] == 200) {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                } else if (res?['code'] == 510) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('로그인 실패'),
                                            content: Text('탈퇴대기중인 회원입니다'),
                                          ));
                                }
                              },
                              child: Container(
                                width: 240,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/splash_login_google.png',
                                      height: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      AppLocalization.of(context)
                                          .get('loginGoogle'),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          if (isLogin)
                            GestureDetector(
                              onTap: () async {
                                var res = await signInApp(context, 'apple');

                                if (res != null) {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }
                              },
                              child: Container(
                                width: 240,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/splash_login_apple.png',
                                      height: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      AppLocalization.of(context)
                                          .get('loginApple'),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          if (isLogin && isDemo)
                            GestureDetector(
                              onTap: () async {
                                var res = await signInApp(context, 'demo');

                                if (res != null) {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }
                              },
                              child: Container(
                                width: 240,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'DEMO LOGIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // 하단 텍스트
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: const Text(
                      '© 2025 DIV. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
