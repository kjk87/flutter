import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:divigo/common/utils/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:divigo/core/localization/app_localization.dart';
import 'dart:math' as math;
import 'package:lottie/lottie.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:health/health.dart';
import 'dart:async';

class SnowParticle {
  double x;
  double y;
  double speed;
  double size;
  double oscillationSpeed;
  double oscillationDistance;

  SnowParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.oscillationSpeed,
    required this.oscillationDistance,
  });
}

class SnowPainter extends CustomPainter {
  final List<SnowParticle> particles;
  final double progress;

  SnowPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      double y = particle.y + (progress * particle.speed);
      y = y % size.height;

      final x = particle.x +
          math.sin((y / size.height) * math.pi * 2) *
              particle.oscillationDistance;

      final opacity = (0.3 + (particle.size - 1) * 0.3).clamp(0.3, 0.8);
      paint.color = Colors.white.withOpacity(opacity);

      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) => true;
}

class MountainPathPainter extends CustomPainter {
  final int currentSteps;
  final BuildContext context;

  MountainPathPainter(this.currentSteps, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final completedPaint = Paint()
      ..color = const Color.fromARGB(255, 61, 241, 70).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final incompletePaint = Paint()
      ..color = const Color(0xFF4A4039).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final completedPointPaint = Paint()
      ..color = const Color.fromARGB(255, 81, 226, 88)
      ..style = PaintingStyle.fill;

    final incompletePointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF4A4039).withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final checkpoints = [
      {'point': size.width * 0.2, 'height': size.height * 0.65, 'steps': 2000},
      {'point': size.width * 0.45, 'height': size.height * 0.5, 'steps': 4000},
      {'point': size.width * 0.35, 'height': size.height * 0.35, 'steps': 6000},
      {'point': size.width * 0.5, 'height': size.height * 0.2, 'steps': 8000},
    ];

    final startX = size.width * 0.67;
    final startY = size.height * 0.75;

    // 경로 그리기
    for (var i = 0; i < checkpoints.length; i++) {
      final path = Path();
      if (i == 0) {
        // 시작점에서 첫 체크포인트까지
        path.moveTo(startX, startY);
        path.quadraticBezierTo(
          size.width * 0.4,
          size.height * 0.7,
          checkpoints[0]['point'] as double,
          checkpoints[0]['height'] as double,
        );
        canvas.drawPath(
            path,
            currentSteps >= (checkpoints[0]['steps'] as int)
                ? completedPaint
                : incompletePaint);
      } else {
        // 체크포인트 간 연결
        path.moveTo(checkpoints[i - 1]['point'] as double,
            checkpoints[i - 1]['height'] as double);
        final controlX = ((checkpoints[i - 1]['point'] as double) +
                (checkpoints[i]['point'] as double)) /
            2;
        path.quadraticBezierTo(
          controlX,
          ((checkpoints[i - 1]['height'] as double) +
                  (checkpoints[i]['height'] as double)) /
              2,
          checkpoints[i]['point'] as double,
          checkpoints[i]['height'] as double,
        );
        canvas.drawPath(
            path,
            currentSteps >= (checkpoints[i]['steps'] as int)
                ? completedPaint
                : incompletePaint);
      }
    }

    // 체크포인트 그리기
    for (var checkpoint in checkpoints) {
      final isCompleted = currentSteps >= (checkpoint['steps'] as int);

      // 원 그리기
      canvas.drawCircle(
        Offset(checkpoint['point'] as double, checkpoint['height'] as double),
        8,
        isCompleted ? completedPointPaint : incompletePointPaint,
      );
      canvas.drawCircle(
        Offset(checkpoint['point'] as double, checkpoint['height'] as double),
        8,
        borderPaint,
      );

      // 걸음 수 텍스트
      textPainter.text = TextSpan(
        text: AppLocalization.of(context)
            .get('stepsFormat')
            .replaceAll('%s', checkpoint['steps'].toString()),
        style: TextStyle(
          color: isCompleted
              ? const Color.fromARGB(255, 87, 241, 95)
              : Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: const Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (checkpoint['point'] as double) - textPainter.width / 2,
          (checkpoint['height'] as double) - 24,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MountainPathPainter oldDelegate) {
    return oldDelegate.currentSteps != currentSteps;
  }
}

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({super.key});

  @override
  State<PedometerScreen> createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _snowController;
  List<SnowParticle>? _particles;
  final _random = math.Random();
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  double _distance = 0.0; // kilometers
  final double _strideLength = 0.7; // 평균 보폭 (미터)
  late SharedPreferences _prefs;
  String _currentDate = '';
  int _lotteryCount = 0;
  Set<int> _rewardedCheckpoints = {};
  int _baseSteps = 0;
  bool _isInitialized = false;
  Timer? _healthKitTimer; // 타이머 변수 추가

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _snowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _checkPermissionAndInitPedometer();
      _isInitialized = true;
    }
  }

  void _initSnowParticles() {
    _particles = List.generate(50, (index) {
      return SnowParticle(
        x: _random.nextDouble() * MediaQuery.of(context).size.width,
        y: _random.nextDouble() * MediaQuery.of(context).size.height * 0.7,
        speed: _random.nextDouble() * 80 + 40,
        size: _random.nextDouble() * 2 + 1,
        oscillationSpeed: _random.nextDouble() * 0.3 + 0.2,
        oscillationDistance: _random.nextDouble() * 15 + 5,
      );
    });
  }

  Future<void> _initializeApp() async {
    _prefs = await SharedPreferences.getInstance();

    _currentDate =
        await _prefs.getString('pedometer_date') ?? _getFormattedDate();

    // 저장된 데이터 불러오기만 하고 초기화하지 않음
    await _loadDailySteps();
    await _loadRewardHistory();
    await _loadLotteryCount();
    await _deleteOldData();

    if (mounted) {
      setState(() {});
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  Future<void> _loadDailySteps() async {
    final today = _getFormattedDate();
    final stepsData = _prefs.getString('steps_data');

    if (stepsData != null) {
      final Map<String, dynamic> data = json.decode(stepsData);

      // 날짜가 변경되었으면 초기화
      if (_currentDate != today) {
        log("날짜 변경 감지 (loadDailySteps): $_currentDate -> $today");
        setState(() {
          _currentDate = today;
          _steps = 0;
          _distance = 0.0;
          _rewardedCheckpoints.clear();
          _baseSteps = 0;
        });
        await _prefs.setString('pedometer_date', today);
        await _saveDailySteps();
        return;
      }

      if (data.containsKey(today)) {
        final todayData = data[today];
        setState(() {
          _steps = todayData['steps'];
          _baseSteps = todayData['baseSteps'];
          _rewardedCheckpoints =
              Set<int>.from(todayData['rewardedCheckpoints']);
          _distance = (_steps * _strideLength) / 1000;
        });
        log("오늘($today) 걸음 수 로드: $_steps");
      } else {
        log("오늘 걸음 수 데이터 없음, 초기화");
        setState(() {
          _steps = 0;
          _distance = 0.0;
          _baseSteps = 0;
          _rewardedCheckpoints.clear();
        });
      }
    } else {
      log("걸음 수 데이터 없음, 초기화");
      setState(() {
        _steps = 0;
        _distance = 0.0;
        _baseSteps = 0;
        _rewardedCheckpoints.clear();
      });
    }
  }

  Future<void> _deleteOldData() async {
    Map<String, dynamic> stepsData = {};
    final savedData = _prefs.getString('steps_data');

    if (savedData != null) {
      stepsData = json.decode(savedData);

      // 이틀 이상 지난 데이터 삭제
      final now = DateTime.now();
      final twoDaysAgo = DateTime(now.year, now.month, now.day - 2);

      stepsData.removeWhere((dateStr, _) {
        try {
          final date = DateTime.parse(dateStr);
          return date.isBefore(twoDaysAgo);
        } catch (e) {
          return true; // 잘못된 형식의 날짜는 삭제
        }
      });
    }
  }

  Future<void> _saveDailySteps() async {
    final today = _getFormattedDate(); // 오늘 날짜를 키로 사용

    // 걸음 수 데이터 저장
    Map<String, dynamic> stepsData = {};
    final savedData = _prefs.getString('steps_data');

    if (savedData != null) {
      stepsData = json.decode(savedData);
    }

    // 오늘 날짜의 걸음 수 업데이트
    stepsData[today] = {
      'steps': _steps,
      'baseSteps': _baseSteps,
      'rewardedCheckpoints': _rewardedCheckpoints.toList(),
      'lastUpdated': DateTime.now().millisecondsSinceEpoch
    };

    await _prefs.setString('steps_data', json.encode(stepsData));
    await _saveRewardHistory();
    await _saveLotteryCount();
  }

  Future<void> _saveRewardHistory() async {
    await _prefs.setStringList('rewarded_checkpoints',
        _rewardedCheckpoints.map((e) => e.toString()).toList());
  }

  Future<void> _saveLotteryCount() async {
    await _prefs.setInt('lottery_count', _lotteryCount);
  }

  Future<void> _loadRewardHistory() async {
    final rewardedList = _prefs.getStringList('rewarded_checkpoints');
    if (rewardedList != null) {
      _rewardedCheckpoints = rewardedList.map((e) => int.parse(e)).toSet();
    }
  }

  Future<void> _loadLotteryCount() async {
    final count = _prefs.getInt('lottery_count');
    if (count != null) {
      setState(() {
        _lotteryCount = count;
      });
    }
  }

  Future<void> _checkPermissionAndInitPedometer() async {
    if (Platform.isAndroid) {
      // Android 코드는 그대로 유지
      final status = await Permission.activityRecognition.status;
      if (status.isDenied) {
        final result = await Permission.activityRecognition.request();
        if (result.isGranted) {
          _setupPedometer();
        } else {
          _showPermissionDeniedDialog();
        }
      } else if (status.isPermanentlyDenied) {
        _showPermissionPermanentlyDeniedDialog();
      } else if (status.isGranted) {
        _setupPedometer();
      }
    } else if (Platform.isIOS) {
      try {
        final health = Health();

        // 걸음 수 권한 확인
        bool hasPermissions =
            await health.hasPermissions([HealthDataType.STEPS]) ?? false;

        // 권한이 없으면 요청
        if (!hasPermissions) {
          // 권한 요청 전에 configure 호출
          await health.configure();

          bool granted = await health.requestAuthorization([
            HealthDataType.STEPS,
            HealthDataType.DISTANCE_WALKING_RUNNING,
          ], permissions: [
            HealthDataAccess.READ,
            HealthDataAccess.READ
          ]);

          log('HealthKit 권한 요청 결과: $granted');

          if (granted) {
            _setupHealthKit();
          } else {
            _showPermissionDeniedDialog();
          }
        } else {
          _setupHealthKit();
        }
      } catch (e) {
        log('HealthKit 권한 처리 오류: $e');
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalization.of(context).get('pedometerNeedPermission')),
        content: Text(
            AppLocalization.of(context).get('pedometerNeedPermissionAosDesc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalization.of(context).get('cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _checkPermissionAndInitPedometer();
            },
            child: Text(AppLocalization.of(context).get('requestPermission')),
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalization.of(context).get('pedometerNeedPermission')),
        content: Text(
            AppLocalization.of(context).get('pedometerNeedPermissionIosDesc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalization.of(context).get('cancel')),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: Text(AppLocalization.of(context).get('moveSetting')),
          ),
        ],
      ),
    );
  }

  void _setupPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      (StepCount event) async {
        final today = _getFormattedDate();
        _currentDate =
            await _prefs.getString('pedometer_date') ?? _getFormattedDate();

        // 날짜가 변경되었는지 확인
        if (_currentDate != today) {
          log("걸음 수 측정 중 날짜 변경 감지: $_currentDate -> $today");
          setState(() {
            _currentDate = today;
            _steps = 0;
            _distance = 0.0;
            _baseSteps = event.steps; // 새로운 날의 시작점으로 설정
            _rewardedCheckpoints.clear();
          });
          await _prefs.setString('pedometer_date', today);
        } else {
          // 오늘 첫 실행이면 baseSteps 설정
          if (_baseSteps == 0) {
            log("오늘 첫 실행 - baseSteps 설정: ${event.steps}");
            _baseSteps = event.steps;
          }

          setState(() {
            _steps = event.steps - _baseSteps;
            _distance = (_steps * _strideLength) / 1000;
          });

          // 체크포인트 확인 및 보상
          final checkpoints = [2000, 4000, 6000, 8000];
          for (var checkpoint in checkpoints) {
            if (_steps >= checkpoint &&
                !_rewardedCheckpoints.contains(checkpoint)) {
              _lotteryCount++;
              _rewardedCheckpoints.add(checkpoint);
              await _awardLotteryTicket(checkpoint);
            }
          }
        }

        await _saveDailySteps();
      },
      onError: (error) {
        print("Pedometer error: $error");
      },
    );
  }

  void _setupHealthKit() {
    _updateHealthKitData(); // 초기 데이터 로드
    _startHealthKitTimer(); // 타이머 시작
  }

  void _startHealthKitTimer() {
    _healthKitTimer?.cancel(); // 기존 타이머가 있다면 취소
    _healthKitTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _updateHealthKitData();
    });
  }

  Future<void> _updateHealthKitData() async {
    try {
      final health = Health();
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      final today = _getFormattedDate();

      final steps = await health.getTotalStepsInInterval(midnight, now);
      if (steps != null) {
        if (_currentDate != today) {
          setState(() {
            _currentDate = today;
            _steps = steps;
            _distance = (_steps * _strideLength) / 1000;
            _baseSteps = 0;
            _rewardedCheckpoints.clear();
          });
        } else {
          setState(() {
            _steps = steps;
            _distance = (_steps * _strideLength) / 1000;
          });
        }

        await _saveDailySteps();

        // 체크포인트 확인 및 보상
        final checkpoints = [2000, 4000, 6000, 8000];
        for (var checkpoint in checkpoints) {
          if (_steps >= checkpoint &&
              !_rewardedCheckpoints.contains(checkpoint)) {
            _lotteryCount++;
            _rewardedCheckpoints.add(checkpoint);
            await _awardLotteryTicket(checkpoint);
          }
        }
      }
    } catch (e) {
      log('HealthKit 데이터 업데이트 오류: $e');
    }
  }

  // 복권 지급 API 호출 함수
  Future<void> _awardLotteryTicket(int step) async {
    try {
      log("복권 지급 API 호출: $step걸음 달성");
      var params = {
        'count': 1,
        'type': 'charge',
        'category': 'pedometer',
        'subject': AppLocalization.of(context)
            .get('pedometerStepsComplete')
            .replaceAll('%s', step.toString())
      };
      var res =
          await httpPost(path: '/member/updateLotteryCount', params: params);
      log("복권 지급 결과: ${res.toString()}");
    } catch (e) {
      log("복권 지급 API 오류: $e");
    }
  }

  String _formatDistance(double distance) {
    return distance.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _healthKitTimer?.cancel(); // 타이머 정리
    WidgetsBinding.instance.removeObserver(this);
    _snowController.dispose();
    _saveDailySteps(); // 앱 종료 시 저장
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isIOS) {
      if (state == AppLifecycleState.resumed) {
        _startHealthKitTimer(); // 앱이 포그라운드로 돌아올 때
      } else if (state == AppLifecycleState.paused) {
        _healthKitTimer?.cancel(); // 앱이 백그라운드로 갈 때
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_particles == null) {
      _initSnowParticles();
    }
    final local = AppLocalization.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 배경 이미지와 눈 애니메이션
            Stack(
              children: [
                // 1. 배경 이미지 (Stack의 크기 기준이 됨)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/pedometer_mountain_background.png',
                    fit: BoxFit.cover,
                  ),
                ),

                // 2. 눈 애니메이션
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: _snowController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter:
                            SnowPainter(_particles!, _snowController.value),
                      );
                    },
                  ),
                ),

                // 3. 등산로 (currentSteps 전달)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: MountainPathPainter(_steps, context),
                  ),
                ),

                // 4. 걷는 사람 애니메이션
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.67 - 20,
                  top: MediaQuery.of(context).size.height * 0.45,
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.transparent,
                    child: Lottie.asset(
                      'assets/animations/walking_person.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),

                // 5. 하단 그라디언트
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),

                // 뒤로가기 버튼
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16, // 상태바 높이 + 여백
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),

            // 하단 컨텐츠
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 걸음 수와 킬로미터 표시
                  Text(
                    '${_formatDistance(_distance)}km',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8B7355),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalization.of(context)
                        .get('pedometerSteps')
                        .replaceAll('%s', _steps.toString()),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4039),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 만보기 안내 카드
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFE9DD),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.directions_walk,
                                color: Color(0xFFFF8C3B),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              AppLocalization.of(context).get('pedometerGuide'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A4039),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalization.of(context).get('pedometerDesc1'),
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8B7355),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalization.of(context).get('pedometerDesc2'),
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8B7355),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalization.of(context).get('pedometerDesc3'),
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8B7355),
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
      ),
    );
  }
}
