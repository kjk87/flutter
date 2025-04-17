import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'dart:math' as math;
import 'dart:developer';
import 'package:divigo/common/utils/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'lottery_guide_screen.dart';

class ScratchLotteryScreen extends StatefulWidget {
  final String? redirectUrl;
  const ScratchLotteryScreen({this.redirectUrl, super.key});

  @override
  State<ScratchLotteryScreen> createState() => _ScratchLotteryScreenState();
}

class _ScratchLotteryScreenState extends State<ScratchLotteryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final scratchKey = GlobalKey<ScratcherState>();
  bool isScratched = false;
  bool isStartedScratching = false;
  late int winningPoints;
  double scratchProgress = 0.0;
  bool isSendingResult = false;

  @override
  void initState() {
    super.initState();
    winningPoints = math.Random().nextInt(10) + 1;
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sendWinningResult(int points) async {
    if (isSendingResult) return;

    setState(() {
      isSendingResult = true;
    });

    try {
      log('당첨 결과 전송 시작: $points 포인트');
      final response = await httpPost(
        path: '/lotteryWinner',
        params: {'amount': points},
      );

      log('당첨 결과 전송 완료: ${response.toString()}');
    } catch (e) {
      log('당첨 결과 전송 오류: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSendingResult = false;
        });
      }
    }
  }

  void _showWinningDialog(int points) {
    _sendWinningResult(points);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.celebration,
                color: Color(0xFF6C72CB),
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                '축하합니다!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$points 포인트에 당첨되었어요!',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6C72CB),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if(widget.redirectUrl != null){
                      final Uri uri = Uri.parse(widget.redirectUrl!);
                      launchUrl(uri, mode: LaunchMode.externalApplication,);
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C72CB),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16), // 오른쪽 여백 추가
            child: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LotteryGuideScreen()),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 24),
          Text(
            '복권을 긁어주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 250,
                height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6C72CB),
                            Color(0xFFCB69C1),
                            Color(0xFF89B5F7),
                            Color(0xFFF7C289),
                            Color(0xFF89F7B5),
                            Color(0xFFF789B5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$winningPoints P',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Scratcher(
                            key: scratchKey,
                            brushSize: 50,
                            threshold: 50,
                            color: Colors.grey[300]!,
                            onScratchStart: () {
                              setState(() => isStartedScratching = true);
                            },
                            onChange: (value) {
                              setState(() => scratchProgress = value);
                            },
                            onScratchEnd: () {
                              if (scratchProgress > 1 && !isScratched) {
                                setState(() => isScratched = true);
                                _showWinningDialog(winningPoints);
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                          if (!isStartedScratching)
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Positioned(
                                  left: _animation.value * 300 - 50,
                                  top: 75,
                                  child: Column(
                                    children: [
                                      Text(
                                        '여기를 긁어보세요',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Icon(
                                        Icons.swipe,
                                        color: Colors.black54,
                                        size: 32,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
