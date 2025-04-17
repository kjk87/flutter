import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/localization/app_localization.dart';

class PedometerSection extends StatefulWidget {
  const PedometerSection({super.key});

  @override
  State<PedometerSection> createState() => _PedometerSectionState();
}

class _PedometerSectionState extends State<PedometerSection> {
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  int _lastStepCount = 0; // 마지막으로 기록된 걸음 수
  final int _goalSteps = 10000;
  DateTime? _lastResetDate;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initPedometer();
  }

  Future<void> _initPedometer() async {
    if (await Permission.activityRecognition.request().isGranted) {
      await _loadLastSteps();
      _initStepCountStream();
      print('Pedometer initialized successfully');
    } else {
      print('Activity recognition permission denied');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalization.of(context).get('permissionDenied'))),
        );
      }
    }
  }

  Future<void> _loadLastSteps() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
      final lastResetStr = prefs.getString('lastResetDate');
      if (lastResetStr != null) {
        _lastResetDate = DateTime.parse(lastResetStr);
      }
    });

    // 자정이 지났는지 확인하고 리셋
    await _checkAndResetSteps();
  }

  Future<void> _checkAndResetSteps() async {
    final now = DateTime.now();
    if (_lastResetDate == null || !_isSameDay(now, _lastResetDate!)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('steps', 0);
      await prefs.setString('lastResetDate', now.toIso8601String());
      setState(() {
        _steps = 0;
        _lastResetDate = now;
      });
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _initStepCountStream() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      (StepCount event) {
        print('Step event received: ${event.steps}');
        if (!_isInitialized) {
          _lastStepCount = event.steps;
          _isInitialized = true;
          print('Initial step count: $_lastStepCount');
          return;
        }

        // 새로운 걸음 수와 마지막 걸음 수의 차이를 계산
        final stepDiff = event.steps - _lastStepCount;
        if (stepDiff > 0) {
          print('Steps difference: $stepDiff');
          _onStepCount(stepDiff);
          _lastStepCount = event.steps;
        }
      },
      onError: (error) {
        print('Pedometer error: $error');
        _onStepCountError(error);
      },
    );
  }

  Future<void> _onStepCount(int stepDiff) async {
    await _checkAndResetSteps();

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps += stepDiff;
    });
    await prefs.setInt('steps', _steps);
    print('Updated total steps: $_steps');

    // 1000걸음 달성마다 포인트 지급
    if (_steps % 1000 == 0) {
      _awardPoints();
    }
  }

  void _onStepCountError(error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).get('stepCountError')),
        ),
      );
    }
  }

  Future<void> _awardPoints() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalization.of(context).get('earnedWalkingPoints'),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF43E97B),
        ),
      );
    }
    // TODO: 포인트 적립 API 호출
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);
    final progress = _steps / _goalSteps;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF43E97B).withOpacity(0.05),
            const Color(0xFF38F9D7).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF43E97B).withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: [
                const Icon(Icons.directions_walk,
                    color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  local.get('dailyWalk'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.stars,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${(_steps / 1000).floor() * 100}P',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          local.get('currentSteps'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _steps.toString(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF43E97B),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                local.get('steps'),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF43E97B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            local.get('goal'),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_goalSteps',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF43E97B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF43E97B),
                        ),
                        minHeight: 24,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  local.get('walkDescription'),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
