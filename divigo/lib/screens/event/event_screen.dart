import 'dart:developer';

import 'package:divigo/screens/event/dial_pad_screen.dart';
import 'package:divigo/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:divigo/screens/event/personal_dial_pad_screen.dart';
import 'package:divigo/services/self_brand_service.dart';
import 'package:divigo/screens/event/event_self_brand_basic_screen.dart';

const bannerList = [
  {
    'image': 'https://cdn.prnumber.com/div/event/7777_banner.png',
    'type': 'normal',
    'title': '#7777 event',
  },
  {
    'image': 'https://cdn.prnumber.com/div/event/1515_banner.png',
    'type': 'normal',
    'title': '#1515 event',
  },
  {
    'image': 'https://cdn.prnumber.com/div/event/8888_banner.png',
    'type': 'video',
    'title': '#8888 event',
  },
];

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void onTabChanged(bool isSelected) {
    log("이벤트 탭 상태 변경: ${isSelected ? '선택됨' : '선택 해제됨'}");

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
    log("이벤트 탭이 선택되었습니다");
    // 데이터 리로드
  }

  // 탭이 선택 해제되었을 때 실행할 함수
  void _onTabUnselected() {
    log("이벤트 탭이 선택 해제되었습니다");
    // 필요한 정리 작업 수행
  }

  // 기타 필요한 작업을 수행하는 함수
  void _performOtherTasks() {
    // 예: 애니메이션 시작, 데이터 갱신 등
    log("기타 작업 수행 중");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Text(
          'EVENT',
          style: TextStyle(
            color: Color(0xFF6C72CB),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6C72CB),
          labelColor: const Color(0xFF6C72CB),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Brand'),
            Tab(text: 'Personal'),
            Tab(text: 'Near By'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventListTab(),
          const PersonalDialPadScreen(),
          _buildNearByTab(),
        ],
      ),
    );
  }

  Widget _buildEventListTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bannerList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DialPadScreen(),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!.withOpacity(0.8),
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: 3,
              ),
              BoxShadow(
                color: Color(0xFF6C72CB).withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Image.network(
                      bannerList[index]['image'] ?? '',
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 240,
                        color: Colors.grey[100],
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[400],
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'HOT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          bannerList[index]['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'D-7',
                          style: TextStyle(
                            color: Color(0xFFE57373),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildNearByTab() {
    final profiles = SelfBrandService.getAllProfiles();

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: profiles.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final profile = profiles[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventSelfBrandBasicScreen(
                  phoneNumber: profile.moveNumber,
                ),
              ),
            );
          },
          child: Container(
            height: 80,
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    profile.backgroundImage,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profile.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
