import 'package:flutter/material.dart';
import '../../core/localization/app_localization.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class RewardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final List<Color> colors;

  const RewardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.colors,
  });
}

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  late YoutubePlayerController _controller;

  final List<RewardItem> rewardItems = const [
    RewardItem(
      title: '미니게임',
      subtitle: '게임으로 포인트를 획득하세요',
      icon: Icons.sports_esports,
      route: '/reward/mini-game',
      colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    ),
    RewardItem(
      title: '주간 랭킹',
      subtitle: '상위 랭커가 되어 보상을 받으세요',
      icon: Icons.emoji_events,
      route: '/reward/ranking',
      colors: [Color(0xFFFF8C3B), Color(0xFFFF6365)],
    ),
    RewardItem(
      title: '친구 초대',
      subtitle: '친구와 함께 포인트를 받으세요',
      icon: Icons.people,
      route: '/reward/invite',
      colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
    ),
    RewardItem(
      title: '출석 체크',
      subtitle: '매일 출석하고 포인트를 모으세요',
      icon: Icons.calendar_today,
      route: '/reward/attendance',
      colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
    ),
    RewardItem(
      title: '만보기',
      subtitle: '걸음 수에 따라 포인트를 획득하세요',
      icon: Icons.directions_walk,
      route: '/reward/pedometer',
      colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: 'wthRMo23n7g',
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        enableJavaScript: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);

    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                player,
                // 포인트 표시 섹션
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        local.get('reward'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CabinetGrotesk',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.1),
                              Theme.of(context).primaryColor.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/more/point-history');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.stars,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '12,500 ${local.get('pointUnit')}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
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
                // 리워드 카드 리스트
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: rewardItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Column(
                        children: [
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, item.route),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: item.colors,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      item.icon,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontFamily: 'CabinetGrotesk',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.subtitle,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.grey[400],
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index < rewardItems.length - 1)
                            Divider(
                              height: 1,
                              color: Colors.grey[200],
                              indent: 16,
                              endIndent: 16,
                            ),
                        ],
                      );
                    }).toList(),
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
