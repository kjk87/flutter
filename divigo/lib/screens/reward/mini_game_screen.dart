import 'package:divigo/widgets/reward/ranking_list_screen.dart';
import 'package:flutter/material.dart';
import '../../widgets/reward/game_section.dart';
import 'package:divigo/core/localization/app_localization.dart';

class MiniGameScreen extends StatelessWidget {
  const MiniGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF6C72CB)),
          title: Text(
            local.get('miniGame'),
            style: const TextStyle(
              color: Color(0xFF6C72CB),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Color(0xFF6C72CB),
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            labelColor: Color(0xFF6C72CB),
            unselectedLabelColor: Colors.grey[400],
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            tabs: [
              Tab(text: local.get('game')),
              Tab(text: local.get('ranking')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 게임 탭
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6C72CB).withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Text(
                          //   local.get('playAndEarn'),
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 24,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // SizedBox(height: 8),
                          Text(
                            local.get('gameRewardGuide'),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // SizedBox(height: 12),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 16, vertical: 8),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white.withOpacity(0.2),
                          //     borderRadius: BorderRadius.circular(12),
                          //   ),
                          //   child: Text(
                          //     local.get('gameRewardGuide'),
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    GameSection(),
                  ],
                ),
              ),
            ),
            // 랭킹 탭
            SingleChildScrollView(
              child: RankingListScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
