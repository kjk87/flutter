import 'package:divcow/bottom_bar_icon.dart';
import 'package:divcow/common/utils/walletUtil.dart';
import 'package:divcow/games/screens/game_list_screen.dart';
import 'package:divcow/guest/screens/guest_main_screen.dart';
import 'package:divcow/profile/screens/profile_screen.dart';
import 'package:divcow/ranking/screens/ranking_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Bottomtabnavigation extends StatefulWidget {
  const Bottomtabnavigation({super.key});

  @override
  State<Bottomtabnavigation> createState() => _BottomtabnavigationState();
}

class _BottomtabnavigationState extends State<Bottomtabnavigation> {
  int _currentTabIndex = 0;


  @override
  void initState() {
    WalletUtil.instance.init(context);
  }

  void _tabSelect(int tabIndex) {
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }

  Widget body() {
    switch(_currentTabIndex) {
      case 0:
        return const GameListScreen();
      case 1:
        return const RankingListScreen();
      case 2:
        return const GuestMainScreen();
      case 3:
        return const ProfileMainScreen();
    }
    return Container();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      //여기부터
      body: body(),
      //여기까지 수정
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: bottomBarIcon('assets/images/gnb_game.png', 'Game', false),
                activeIcon: bottomBarIcon('assets/images/gnb_game.png', 'Game', true),
                label: 'Game'
            ),
            BottomNavigationBarItem(
                icon: bottomBarIcon('assets/images/gnb_ranking.png', 'Ranking', false),
                activeIcon: bottomBarIcon('assets/images/gnb_ranking.png', 'Ranking', true),
                label: 'Ranking'
            ),
            BottomNavigationBarItem(
                icon: bottomBarIcon('assets/images/gnb_guest.png', 'Guest', false),
                activeIcon: bottomBarIcon('assets/images/gnb_guest.png', 'Guest', true),
                label: 'Guest'
            ),
            BottomNavigationBarItem(
                icon: bottomBarIcon('assets/images/gnb_profile.png', 'Profile', false),
                activeIcon: bottomBarIcon('assets/images/gnb_profile.png', 'Profile', true),
                label: 'Profile'
            ),
          ],
          currentIndex: _currentTabIndex,
          onTap: (value) => _tabSelect(value),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff000000),
          selectedFontSize: 0
      ),
    );
  }
}