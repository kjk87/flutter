import 'dart:developer';
import 'package:divigo/screens/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../wallet/wallet_screen.dart';
import '../event/event_screen.dart';
import '../lottery/lottery_screen.dart';
// import '../reward/reward_screen.dart';
import '../../core/localization/app_localization.dart';

// 탭 변경 감지를 위한 인터페이스
mixin TabAwareWidget {
  void onTabChanged(bool isSelected);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 각 화면의 GlobalKey를 생성
  final walletKey = GlobalKey<State>();
  final lotteryKey = GlobalKey<State>();
  final eventKey = GlobalKey<State>();
  final settingsKey = GlobalKey<State>();

  late final List<Widget> _screens = [
    WalletScreen(key: walletKey),
    LotteryScreen(key: lotteryKey),
    EventScreen(key: eventKey),
    // const CoverDanceScreen(),
    ProfileMainScreen(key: settingsKey),
  ];

  @override
  void initState() {
    super.initState();
    // PopupManager 관련 코드 제거
  }

  // 탭 변경 시 호출되는 메서드
  void _onTabChanged(int index) {
    log("탭 변경: $_selectedIndex -> $index");

    // 이전 탭에 알림
    _notifyTab(_selectedIndex, false);

    setState(() {
      _selectedIndex = index;
    });

    // 새 탭에 알림
    _notifyTab(_selectedIndex, true);
  }

  // 탭에 알림을 보내는 메서드
  void _notifyTab(int index, bool isSelected) {
    GlobalKey<State>? key;

    switch (index) {
      case 0:
        key = walletKey;
        break;
      case 1:
        key = lotteryKey;
        break;
      case 2:
        key = eventKey;
        break;
      case 3:
        key = settingsKey;
        break;
    }

    if (key != null && key.currentState != null) {
      final state = key.currentState;
      if (state is TabAwareWidget) {
        log("탭 $index에 알림 전송: $isSelected");
        (state as TabAwareWidget).onTabChanged(isSelected);
      } else {
        log("탭 $index는 TabAwareWidget을 구현하지 않음");
      }
    } else {
      log("탭 $index의 상태가 null");
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);
    log('Building HomeScreen with index: $_selectedIndex');
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
              color: Colors.grey[900]!,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabChanged,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.deepPurple[300],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.account_balance_wallet_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_balance_wallet),
              ),
              label: AppLocalization.of(context).get('wallet'),
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.confirmation_number_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6C72CB).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.confirmation_number),
              ),
              label: AppLocalization.of(context).get('lottery'),
            ),
            // BottomNavigationBarItem(
            //   icon: Container(
            //     padding: const EdgeInsets.all(8),
            //     child: const Icon(Icons.music_note_outlined),
            //   ),
            //   activeIcon: Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: Colors.purple.withOpacity(0.2),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: const Icon(Icons.music_note),
            //   ),
            //   label: 'CoverDance',
            // ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.event_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.event),
              ),
              label: AppLocalization.of(context).get('event'),
            ),
            // NavigationDestination(
            //   icon: const Icon(Icons.card_giftcard_outlined),
            //   selectedIcon: const Icon(Icons.card_giftcard),
            //   label: 'Reward',
            // ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.more_horiz_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.more_horiz),
              ),
              label: AppLocalization.of(context).get('more'),
            ),
          ],
        ),
      ),
    );
  }
}
