import 'package:divigo/common/utils/admobUtil.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/screens/lottery/scratch_lottery_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:divigo/core/localization/app_localization.dart';

class PatternMemoryGame extends StatefulWidget {
  const PatternMemoryGame({Key? key}) : super(key: key);

  @override
  State<PatternMemoryGame> createState() => _PatternMemoryGameState();
}

class _PatternMemoryGameState extends State<PatternMemoryGame> {
  final int gridSize = 3;
  late List<List<bool>> grid;
  late List<List<bool>> playerGrid;
  List<String> gameHistory = [];
  int score = 0;
  int level = 1;
  bool isShowingPattern = false;
  bool isPlayerTurn = false;
  bool isGameOver = false;
  int patternLength = 3;
  List<Point<int>> pattern = [];
  int playerInputCount = 0;
  Timer? _patternTimer;
  Timer? _resetTimer;
  Timer? _feedbackTimer;
  Timer? _showPatternTimer;
  List<Timer> _patternShowTimers = [];
  bool isGameStarted = false;
  int lives = 3; // 목숨 추가
  final int maxLevel = 10; // 최대 레벨 설정
  bool showLevelStart = false; // 레벨 시작 텍스트 표시 여부

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    _patternTimer?.cancel();
    _resetTimer?.cancel();
    _feedbackTimer?.cancel();
    _showPatternTimer?.cancel();
    for (var timer in _patternShowTimers) {
      timer.cancel();
    }
    _patternShowTimers.clear();
    super.dispose();
  }

  void _initializeGame() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, false));
    playerGrid = List.generate(gridSize, (_) => List.filled(gridSize, false));
    lives = 3;
    level = 1;
    score = 0;
    patternLength = level;
  }

  void _startGame() {
    setState(() {
      isGameStarted = true;
    });

    _generatePattern();
  }

  void _generatePattern() {
    pattern.clear();
    for (int i = 0; i < patternLength; i++) {
      pattern.add(Point(
        Random().nextInt(gridSize),
        Random().nextInt(gridSize),
      ));
    }
    _showPattern();
  }

  void _showPattern() {
    if (!mounted) return;

    for (var timer in _patternShowTimers) {
      timer.cancel();
    }
    _patternShowTimers.clear();

    setState(() {
      isShowingPattern = true;
      grid = List.generate(
        gridSize,
        (_) => List.generate(gridSize, (_) => false),
      );
    });

    int delay = 0;
    for (var point in pattern) {
      if (!mounted) return;

      _patternShowTimers.add(Timer(Duration(milliseconds: delay), () {
        if (mounted) {
          setState(() {
            grid[point.x][point.y] = true;
          });
        }
      }));

      _patternShowTimers.add(Timer(Duration(milliseconds: delay + 500), () {
        if (mounted) {
          setState(() {
            grid[point.x][point.y] = false;
          });
        }
      }));

      delay += 1000;
    }

    _showPatternTimer = Timer(Duration(milliseconds: delay), () {
      if (mounted) {
        setState(() {
          isShowingPattern = false;
          isPlayerTurn = true;
        });
      }
    });
  }

  Widget _buildGridItem(int row, int col) {
    bool isHighlighted = grid[row][col];
    bool isPlayerSelected = playerGrid[row][col];

    return GestureDetector(
      onTapDown: (_) {
        if (!isShowingPattern && !isGameOver && isPlayerTurn) {
          setState(() {
            playerGrid[row][col] = true; // 즉시 시각적 피드백
          });
        }
      },
      onTapUp: (_) {
        if (!isShowingPattern && !isGameOver && isPlayerTurn) {
          _handlePlayerInput(row, col);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isHighlighted || isPlayerSelected
              ? Color(0xFFFF5E62)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFFF5E62).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFF5E62).withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePlayerInput(int row, int col) {
    final local = AppLocalization.of(context);
    if (!isPlayerTurn) return;

    Point<int> input = Point(row, col);
    Point<int> expectedPoint = pattern[playerInputCount];

    setState(() async {
      if (input.x == expectedPoint.x && input.y == expectedPoint.y) {
        playerInputCount++;

        if (playerInputCount == pattern.length) {
          isPlayerTurn = false; // 입력 비활성화
          if (level == maxLevel) {
            // 게임 클리어
            gameHistory.insert(0, local.get('gameComplete'));
            isGameOver = true;

            AdmobUtil.instance.showInterstitialAd();

            var params = {
              'category': 'pattern',
              'type': 'charge',
              'count': 1,
              'subject': 'pattern memory game',
              'comment': 'pattern memory game',
            };

            var res = await httpPost(
                path: '/member/updateLotteryCount', params: params);

            if (res['code'] == 200) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScratchLotteryScreen()));
            }
          } else {
            // 성공 메시지 표시 후 다음 레벨로
            gameHistory.insert(0,
                local.get('levelSuccess').replaceAll('%s', level.toString()));
            score += (level * 100);

            // 성공 표시를 보여주기 위해 딜레이 추가
            Timer(Duration(seconds: 1), () {
              if (mounted) {
                setState(() {
                  level++;
                  _startNextLevel();
                });
              }
            });
          }
        } else {
          // 각 입력이 맞을 때마다 시각적 피드백
          grid[row][col] = true;
          Timer(Duration(milliseconds: 300), () {
            if (mounted) {
              setState(() {
                grid[row][col] = false;
              });
            }
          });
        }
      } else {
        lives--;
        if (lives <= 0) {
          // 게임 오버 시 다이얼로그 표시
          gameHistory.insert(
              0, local.get('gameOver').replaceAll('%s', level.toString()));
          isGameOver = true;
          _showGameOverDialog(); // 다이얼로그 표시 추가
        } else {
          gameHistory.insert(
              0, local.get('wrongPattern').replaceAll('%s', lives.toString()));
          _resetLevel();
        }
      }
    });

    _feedbackTimer?.cancel();
    if (mounted) {
      _feedbackTimer = Timer(Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            playerGrid = List.generate(
              gridSize,
              (_) => List.generate(gridSize, (_) => false),
            );
          });
        }
      });
    }
  }

  void _showGameOverDialog() {
    final local = AppLocalization.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          local.get('patternOver'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF5E62),
          ),
        ),
        content: Text(
          local
              .get('patternGameOverMessage')
              .replaceAll('%s', level.toString()),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              local.get('quit'),
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _initializeGame();
                isGameOver = false;
                isGameStarted = true;
                _generatePattern();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF5E62),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              local.get('retry'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startNextLevel() {
    _patternTimer?.cancel();
    setState(() {
      patternLength = level;
      isPlayerTurn = false;
      playerInputCount = 0;
      playerGrid = List.generate(
        gridSize,
        (_) => List.generate(gridSize, (_) => false),
      );
    });

    _generatePattern();
  }

  void _resetLevel() {
    _resetTimer?.cancel();
    setState(() {
      isPlayerTurn = false;
      playerInputCount = 0;
      playerGrid = List.generate(
        gridSize,
        (_) => List.generate(gridSize, (_) => false),
      );
    });

    if (mounted) {
      _resetTimer = Timer(Duration(milliseconds: 1500), () {
        if (mounted) _showPattern();
      });
    }
  }

  Widget _buildGameBody() {
    final local = AppLocalization.of(context);

    if (!isGameStarted) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.only(left: 8),
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            local.get('howToPlay'),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF5E62),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '${local.get('patternRule1')}\n'
                            '${local.get('patternRule2')}\n'
                            '${local.get('patternRule3')}\n'
                            '${local.get('patternRule4')}\n'
                            '${local.get('patternRule5')}',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _startGame(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF5E62),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          local.get('startGame'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.only(left: 8),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      local.get('patternMemory'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            local
                                .get('score')
                                .replaceAll('%s', score.toString()),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF5E62),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                local
                                    .get('level')
                                    .replaceAll('%s', level.toString()),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF5E62),
                                ),
                              ),
                              SizedBox(width: 12),
                              Row(
                                children: List.generate(
                                  3,
                                  (index) => Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.favorite,
                                      color: index < lives
                                          ? Color(0xFFFF5E62)
                                          : Color(0xFFFF5E62).withOpacity(0.3),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        flex: 4,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: GridView.builder(
                              padding: EdgeInsets.all(8),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridSize,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: gridSize * gridSize,
                              itemBuilder: (context, index) {
                                int row = index ~/ gridSize;
                                int col = index % gridSize;
                                return _buildGridItem(row, col);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF5E62), Color(0xFFFF9966)],
              ),
            ),
            child: SafeArea(
              child: _buildGameBody(),
            ),
          ),
        ],
      ),
    );
  }
}
