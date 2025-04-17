import 'package:divigo/widgets/cover_dance/challenge_section.dart';
import 'package:divigo/widgets/cover_dance/contest_section.dart';
import 'package:divigo/widgets/cover_dance/following_section.dart';
import 'package:divigo/widgets/cover_dance/recommended_section.dart';
import 'package:flutter/material.dart';
import '../../core/localization/app_localization.dart';

class CoverDanceScreen extends StatefulWidget {
  const CoverDanceScreen({super.key});

  @override
  State<CoverDanceScreen> createState() => _CoverDanceScreenState();
}

class _CoverDanceScreenState extends State<CoverDanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'COVER DANCE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: 검색 기능 구현
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // TODO: 알림 기능 구현
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 2,
          tabs: const [
            Tab(text: '추천'),
            Tab(text: '챌린지'),
            Tab(text: '대회'),
            Tab(text: '팔로잉'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          RecommendedSection(),
          ChallengeSection(),
          ContestSection(),
          FollowingSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 영상 업로드 기능 구현
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
