import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:divigo/models/self_brand_profile.dart';
import 'package:divigo/services/self_brand_service.dart';
import 'package:divigo/screens/event/event_self_brand_posting_screen.dart';
import 'package:divigo/screens/event/event_self_brand_message_screen.dart';

class EventSelfBrandBasicScreen extends StatefulWidget {
  final String phoneNumber;

  const EventSelfBrandBasicScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<EventSelfBrandBasicScreen> createState() =>
      _EventSelfBrandBasicScreenState();
}

class _EventSelfBrandBasicScreenState extends State<EventSelfBrandBasicScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  late final SelfBrandProfile profile;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    profile = SelfBrandService.getProfile(widget.phoneNumber)!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  void _openPhantomWallet() async {
    try {
      await _launchURL('phantom://');
    } catch (e) {
      // phantom 앱이 없는 경우 스토어로 이동
      await _launchURL('https://phantom.app/download');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white, size: 28),
            onPressed: () {
              Share.share('Check out my personal brand page!');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.only(
            bottom: _isExpanded
                ? MediaQuery.of(context).size.height * 0.5 + 16
                : 130),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF4A90E2),
            onPressed: _openPhantomWallet,
            shape: const CircleBorder(),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 28,
                  color: Colors.white,
                ),
                SizedBox(height: 3),
                Text(
                  'Wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          Image.asset(
            profile.backgroundImage,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  profile.phoneNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profile.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/ic_telegram.png',
                          width: 48),
                      onPressed: () => _launchURL(profile.telegramUrl),
                    ),
                    IconButton(
                      icon: Image.asset('assets/images/ic_x.png', width: 48),
                      onPressed: () => _launchURL(profile.xUrl),
                    ),
                    IconButton(
                      icon: Image.asset('assets/images/ic_youtube.png',
                          width: 48),
                      onPressed: () => _launchURL(profile.youtubeUrl),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isExpanded
                      ? MediaQuery.of(context).size.height * 0.5
                      : 135,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => _makePhoneCall(profile.phoneNumber),
                              child: _buildInfoColumn(Icons.phone, 'Tel'),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventSelfBrandMessageScreen(
                                      profile: profile,
                                    ),
                                  ),
                                );
                              },
                              child: _buildInfoColumn(Icons.message, 'Message'),
                            ),
                            InkWell(
                              onTap: () => _launchURL(profile.homepageUrl),
                              child:
                                  _buildInfoColumn(Icons.language, 'Homepage'),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventSelfBrandPostingScreen(
                                      profile: profile,
                                    ),
                                  ),
                                );
                              },
                              child:
                                  _buildInfoColumn(Icons.post_add, 'Posting'),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: AnimatedRotation(
                          duration: const Duration(milliseconds: 300),
                          turns: _isExpanded ? 0.5 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        onPressed: _toggleExpand,
                      ),
                      if (_isExpanded)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                profile.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
