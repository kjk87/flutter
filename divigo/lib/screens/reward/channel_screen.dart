import 'package:divigo/common/utils/http.dart';
import 'package:divigo/common/utils/loginInfo.dart';
import 'package:divigo/models/member.dart';
import 'package:divigo/models/sns_reward.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/localization/app_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  late Future<SnsReward> _dataFuture;
  late Member member;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<SnsReward> _fetchData() async {
    member = (await getUser(context))!;
    final result = await httpGetWithCode(path: '/snsReward');
    if (result == null) {
      return SnsReward(
          userKey: member.userKey,
          youtube: false,
          telegram: false,
          discord: false,
          x: false,
          instagram: false);
    } else {
      return SnsReward.fromJson(result);
    }
  }

  String get _placeholderSvg => '''
    <svg width="200" height="200" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
      <circle cx="100" cy="70" r="40" fill="#FF8C3B"/>
      <rect x="30" y="120" width="140" height="40" rx="20" fill="#FF6365"/>
      <circle cx="60" cy="70" r="15" fill="white"/>
      <circle cx="140" cy="70" r="15" fill="white"/>
      <path d="M70 100 Q100 120 130 100" stroke="white" stroke-width="5" fill="none"/>
    </svg>
  ''';

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF6C72CB)),
        title: Text(
          local.get('channelSubscribe'),
          style: const TextStyle(
            color: Color(0xFF6C72CB),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C72CB),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dataFuture = _fetchData();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C72CB),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // When data is loaded successfully
          return SingleChildScrollView(
            child: Column(
              children: [
                // 상단 섹션
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      left: 16, top: 0, right: 16, bottom: 0),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
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
                      Text(
                        local.get('channelSubscribeTitle'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        local.get('channelSubscribeSubtitle'),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // SNS 리스트
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // _buildChannelItem(
                      //   context,
                      //   icon: 'assets/images/ic_youtube.png',
                      //   isSubscribed: snapshot.data!.youtube ?? false,
                      //   title: 'YouTube',
                      //   subtitle: local.get('youtubeDesc'),
                      //   color: const Color(0xFFFF0000),
                      //   onTap: () =>
                      //       _launchUrl('https://youtube.com/channel/xxx'),
                      // ),
                      const SizedBox(height: 12),
                      _buildChannelItem(
                        context,
                        icon: 'assets/images/ic_telegram.png',
                        isSubscribed: snapshot.data!.telegram ?? false,
                        title: 'Telegram',
                        type: 'telegram',
                        subtitle: local.get('telegramDesc'),
                        color: const Color(0xFF0088CC),
                        onTap: () => _launchUrl('https://t.me/divcowchannel'),
                      ),
                      const SizedBox(height: 12),
                      _buildChannelItem(
                        context,
                        icon: 'assets/images/ic_discord.png',
                        isSubscribed: snapshot.data!.discord ?? false,
                        title: 'Discord',
                        type: 'discord',
                        subtitle: local.get('discordDesc'),
                        color: const Color(0xFF7289DA),
                        onTap: () => _launchUrl('https://discord.gg/ywCJubu4'),
                      ),
                      const SizedBox(height: 12),
                      _buildChannelItem(
                        context,
                        icon: 'assets/images/ic_x.png',
                        isSubscribed: snapshot.data!.x ?? false,
                        title: 'X',
                        type: 'x',
                        subtitle: local.get('xDesc'),
                        color: const Color(0xFF212121),
                        onTap: () => _launchUrl('https://x.com/ChainDiv7973'),
                      ),
                      const SizedBox(height: 12),
                      // _buildChannelItem(
                      //   context,
                      //   icon: 'assets/images/ic_instagram.png',
                      //   isSubscribed: snapshot.data!.instagram ?? false,
                      //   title: 'Instagram',
                      //   subtitle: local.get('instagramDesc'),
                      //   color: const Color(0xFFE1306C),
                      //   onTap: () => _launchUrl('https://instagram.com/xxx'),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChannelItem(
    BuildContext context, {
    required String icon,
    required bool isSubscribed,
    required String title,
    required String subtitle,
    required String type,
    required Color color,
    required VoidCallback onTap,
  }) {
    final local = AppLocalization.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final params = {
              'type' : type
            };
            await httpPost(path: '/snsReward', params: params);
            setState(() {
              _dataFuture = _fetchData();
            });
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    // Icon 위젯 대신 Image.asset 사용
                    icon, // icon 매개변수 사용
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSubscribed ? color.withOpacity(0.1) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSubscribed ? color : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSubscribed
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        size: 16,
                        color: isSubscribed ? color : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isSubscribed
                            ? local.get('subscribed')
                            : local.get('subscribe'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSubscribed ? color : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
