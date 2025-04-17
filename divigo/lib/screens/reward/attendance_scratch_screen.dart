import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import '../../core/localization/app_localization.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class AttendanceScratchScreen extends StatefulWidget {
  final int reward;
  const AttendanceScratchScreen({super.key, required this.reward});

  @override
  State<AttendanceScratchScreen> createState() =>
      _AttendanceScratchScreenState();
}

class _AttendanceScratchScreenState extends State<AttendanceScratchScreen>
    with TickerProviderStateMixin {
  final scratchKey = GlobalKey<ScratcherState>();
  bool _isScratched = false;
  double scratchProgress = 0;
  bool isFingerUp = false;
  double _brushSize = 40;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF4A4039)),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C3B).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Scratcher(
                  brushSize: _brushSize,
                  threshold: 50,
                  color: const Color(0xFFFF8C3B),
                  onChange: (value) {
                    if (value > 0.5 && !_isScratched) {
                      setState(() => _isScratched = true);
                    }
                  },
                  onThreshold: () {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        Navigator.of(context).pop(true);
                      }
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: const Image(
                                  image:
                                      AssetImage('assets/images/buff_icon.png'),
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.reward}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF8C3B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'BUFF',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4A4039),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isScratched
                  ? local.get('keepScratching')
                  : local.get('startScratching'),
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF4A4039),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
