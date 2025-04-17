import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuessResult {
  final int strikes;
  final int balls;
  GuessResult(this.strikes, this.balls);
}

class NumberBaseballMultiplayerGame extends StatefulWidget {
  const NumberBaseballMultiplayerGame({super.key});

  @override
  State<NumberBaseballMultiplayerGame> createState() =>
      _NumberBaseballMultiplayerGameState();
}

class _NumberBaseballMultiplayerGameState
    extends State<NumberBaseballMultiplayerGame> {
  final DatabaseReference _gameRef =
      FirebaseDatabase.instance.ref().child('games');
  final TextEditingController _roomNameController = TextEditingController();
  Stream<DatabaseEvent>? _roomsStream;

  @override
  void initState() {
    super.initState();
    _roomsStream = _gameRef.onValue;
  }

  Future<void> _createRoom() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('방 만들기'),
        content: TextField(
          controller: _roomNameController,
          decoration: InputDecoration(hintText: '방 이름을 입력하세요'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _roomNameController.text),
            child: Text('만들기'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final newRoomRef = _gameRef.push();
      await newRoomRef.set({
        'name': result,
        'hostId': FirebaseAuth.instance.currentUser!.uid,
        'playerCount': 1,
        'maxPlayers': 5,
        'status': 'waiting', // waiting, playing, finished
        'createdAt': ServerValue.timestamp,
        'players': {
          FirebaseAuth.instance.currentUser!.uid: {
            'name': FirebaseAuth.instance.currentUser!.displayName,
            'isHost': true,
            'joinedAt': ServerValue.timestamp,
          }
        }
      });

      // 방으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameRoomScreen(roomId: newRoomRef.key!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 배너
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6C72CB).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.groups,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '함께 도전하세요!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '친구들과 협력하여 빠르게 정답을 맞춰보세요',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 방 목록
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _roomsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF6C72CB)),
                    ),
                  );
                }

                final rooms = <MapEntry<String, dynamic>>[];
                final value = snapshot.data!.snapshot.value;
                if (value != null && value is Map) {
                  rooms.addAll(
                    (value as Map<dynamic, dynamic>)
                        .entries
                        .where((e) =>
                            (e.value as Map)['status'] == 'waiting' &&
                            (e.value as Map)['playerCount'] < 5)
                        .map((e) => MapEntry(e.key.toString(), e.value)),
                  );
                }

                if (rooms.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.meeting_room_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          '참여 가능한 방이 없습니다',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index].value as Map;
                    final roomId = rooms[index].key;
                    final playerCount = room['playerCount'] as int;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GameRoomScreen(roomId: roomId),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF6C72CB),
                                        Color(0xFFCB69C1)
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$playerCount/5',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        room['name'] as String,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '방장: ${(room['players'] as Map).values.first['name']}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF6C72CB),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6C72CB).withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _createRoom,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    '방 만들기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameRoomScreen extends StatefulWidget {
  final String roomId;

  const GameRoomScreen({super.key, required this.roomId});

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  final DatabaseReference _roomRef =
      FirebaseDatabase.instance.ref().child('games');
  bool _isHost = false;
  StreamSubscription? _roomSubscription;
  late DatabaseReference _connectedRef;
  late DatabaseReference _playerStatusRef;

  @override
  void initState() {
    super.initState();
    _setupConnectionHandling();
    _joinRoom();
    _startRoomListener();
  }

  void _setupConnectionHandling() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    _connectedRef = FirebaseDatabase.instance.ref('.info/connected');
    _playerStatusRef = _roomRef
        .child(widget.roomId)
        .child('players')
        .child(userId)
        .child('online');

    _connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
        // 연결이 활성화되면 온라인 상태 업데이트 및 연결 해제 시 처리 설정
        _playerStatusRef.onDisconnect().remove();
        _playerStatusRef.set(true);

        // 방 전체에 대한 cleanup 설정
        _roomRef
            .child(widget.roomId)
            .child('players')
            .child(userId)
            .onDisconnect()
            .remove();

        _roomRef
            .child(widget.roomId)
            .child('playerCount')
            .onDisconnect()
            .set(ServerValue.increment(-1));
      }
    });
  }

  void _startRoomListener() {
    _roomSubscription = _roomRef.child(widget.roomId).onValue.listen((event) {
      if (!mounted) return;

      // 방이 삭제되었는지 확인
      if (!event.snapshot.exists) {
        _showRoomDeletedDialog();
        return;
      }

      final roomData = event.snapshot.value as Map;
      setState(() {
        _isHost = roomData['hostId'] == FirebaseAuth.instance.currentUser!.uid;
      });
    });
  }

  void _showRoomDeletedDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '방이 삭제되었습니다',
          style: TextStyle(
            color: Color(0xFF6C72CB),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '방장이 퇴장하여 방이 삭제되었습니다.\n대기실로 이동합니다.',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              Navigator.of(context).pop(); // 게임방 나가기
            },
            child: Text(
              '확인',
              style: TextStyle(
                color: Color(0xFF6C72CB),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cleanupRoom();
    super.dispose();
  }

  Future<void> _cleanupRoom() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final snapshot = await _roomRef.child(widget.roomId).get();
      if (!snapshot.exists) return;

      final roomData = snapshot.value as Map;
      final players = roomData['players'] as Map?;

      if (players == null || players.length <= 1) {
        // 마지막 플레이어면 방 삭제
        await _roomRef.child(widget.roomId).remove();
      } else {
        // 플레이어 정보만 제거
        await _roomRef.child(widget.roomId).update({
          'playerCount': (roomData['playerCount'] as int) - 1,
          'players/$userId': null,
        });
      }
    } catch (e) {
      print('방 정리 중 에러: $e');
    }
  }

  Future<void> _joinRoom() async {
    print('_joinRoom 실행됨'); // 디버그 로그
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userName = FirebaseAuth.instance.currentUser!.displayName ?? '플레이어';

    final snapshot = await _roomRef.child(widget.roomId).get();
    if (!snapshot.exists) return;

    final roomData = snapshot.value as Map;
    setState(() {
      _isHost = roomData['hostId'] == userId;
    });

    if (!_isHost) {
      try {
        final updates = {
          '/playerCount': (roomData['playerCount'] as int) + 1,
          '/players/$userId': {
            'name': userName,
            'isHost': false,
            'joinedAt': ServerValue.timestamp,
          },
        };

        print('업데이트할 데이터: $updates'); // 디버그 로그
        await _roomRef.child(widget.roomId).update(updates);
        print('업데이트 완료'); // 디버그 로그
      } catch (e) {
        print('참가 에러: $e'); // 디버그 로그
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (mounted) {
          await _cleanupRoom();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<DatabaseEvent>(
          stream: _roomRef.child(widget.roomId).onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
              print('데이터 없음');
              return Center(child: CircularProgressIndicator());
            }

            final roomData =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            print('전체 방 데이터: $roomData');

            final playersData = roomData['players'] as Map<dynamic, dynamic>?;
            print('플레이어 데이터: $playersData');

            if (playersData == null) {
              print('플레이어 데이터가 null');
              return Center(child: Text('플레이어 정보 없음'));
            }

            final players = playersData.entries.map((entry) {
              print('플레이어 항목: ${entry.key} - ${entry.value}');
              return {
                'id': entry.key,
                ...entry.value as Map<dynamic, dynamic>,
              };
            }).toList();

            print('변환된 플레이어 목록: $players');

            final isPlaying = roomData['status'] == 'playing';

            if (isPlaying) {
              return GamePlayScreen(roomId: widget.roomId);
            }

            return SafeArea(
              child: Column(
                children: [
                  // 커스텀 앱바
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.arrow_back_ios,
                                color: Color(0xFF6C72CB)),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            roomData['name'] as String,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C72CB),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 상단 정보 카드
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF6C72CB).withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '게임 대기중',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${players.length}/5 참가자',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 플레이어 목록
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '참가자 목록',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: players.length,
                              itemBuilder: (context, index) {
                                final player = players[index];
                                final isHost = player['isHost'] ?? false;

                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: isHost
                                                ? [
                                                    Color(0xFFFFD700),
                                                    Color(0xFFFFA500)
                                                  ]
                                                : [
                                                    Color(0xFF6C72CB),
                                                    Color(0xFFCB69C1)
                                                  ],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            isHost ? Icons.star : Icons.person,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              player['name'] as String,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              isHost ? '방장' : '참가자',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 시작 버튼
                  if (_isHost)
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF6C72CB).withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _startGame,
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: Text(
                                '게임 시작',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _startGame() async {
    final answer = _generateAnswer();
    await _roomRef.child(widget.roomId).update({
      'status': 'playing',
      'answer': answer,
      'startTime': ServerValue.timestamp,
    });
  }

  String _generateAnswer() {
    final random = Random();
    final numbers = List.generate(10, (i) => i)..shuffle(random);
    return numbers.take(4).join();
  }
}

class GamePlayScreen extends StatefulWidget {
  final String roomId;

  const GamePlayScreen({super.key, required this.roomId});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  final DatabaseReference _gameRef =
      FirebaseDatabase.instance.ref().child('games');
  final TextEditingController _guessController = TextEditingController();
  String? _roomId;
  List<String> _players = [];
  List<GuessRecord> _guessHistory = [];
  String? _answer;
  Timer? _timer;
  int _remainingTime = 300; // 5분
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _roomId = widget.roomId;
    _startListening();
    _startTimer();
  }

  void _startListening() {
    _gameRef.child(_roomId!).onValue.listen((event) {
      if (!mounted) return;

      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final guessesData = data['guesses'];
      print('받은 추측 데이터: $guessesData'); // 디버그 로그

      setState(() {
        _players = ((data['players'] ?? {}) as Map)
            .values
            .map((p) => p['name'] as String)
            .toList();

        if (guessesData == null) {
          _guessHistory = [];
        } else if (guessesData is Map) {
          try {
            _guessHistory = guessesData.entries
                .map((e) => GuessRecord.fromMap(e.value as Map))
                .toList()
              ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
          } catch (e) {
            print('Guess 데이터 변환 에러: $e');
            _guessHistory = [];
          }
        }

        _answer = data['answer'] as String?;
      });
    });
  }

  void _submitGuess(String guess) async {
    if (guess.length != 4 || !RegExp(r'^\d{4}$').hasMatch(guess)) return;

    final result = _checkGuess(guess);
    final newGuess = GuessRecord(
      playerId: FirebaseAuth.instance.currentUser!.uid,
      playerName: FirebaseAuth.instance.currentUser!.displayName!,
      guess: guess,
      strikes: result.strikes,
      balls: result.balls,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    // 현재 시간을 키로 사용
    final guessRef = _gameRef
        .child(_roomId!)
        .child('guesses')
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    await guessRef.set(newGuess.toMap());

    if (result.strikes == 4) {
      _showCongratulationsDialog(
        FirebaseAuth.instance.currentUser!.displayName ?? '플레이어',
        _remainingTime,
      );
      _endGame(true);
    }
  }

  void _endGame(bool isWin) {
    setState(() {
      _isGameOver = true;
    });
    _timer?.cancel();
    // 게임 결과 저장 및 순위 업데이트
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _endGame(false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Color(0xFF6C72CB),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C72CB),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48), // 좌우 균형을 위한 여백
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _guessHistory.length,
              itemBuilder: (context, index) {
                if (index >= _guessHistory.length) {
                  return null;
                }

                final guess = _guessHistory[index];
                print('현재 인덱스: $index, 전체 기록: ${_guessHistory.length}');

                final isCorrect = guess.strikes == 4;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: isCorrect
                        ? LinearGradient(
                            colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
                          )
                        : null,
                    color: isCorrect ? null : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: isCorrect
                            ? Color(0xFF6C72CB).withOpacity(0.3)
                            : Colors.grey.withOpacity(0.1),
                        blurRadius: isCorrect ? 10 : 5,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          isCorrect ? Colors.white : Color(0xFF6C72CB),
                      child: Text(
                        guess.playerName.isNotEmpty ? guess.playerName[0] : '?',
                        style: TextStyle(
                          color: isCorrect ? Color(0xFF6C72CB) : Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      '${guess.guess} (${guess.strikes}S ${guess.balls}B)',
                      style: TextStyle(
                        color: isCorrect ? Colors.white : Colors.black87,
                        fontWeight:
                            isCorrect ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      guess.playerName,
                      style: TextStyle(
                        color: isCorrect ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    trailing: isCorrect
                        ? Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 28,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _guessController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: InputDecoration(
                      hintText: '4자리 숫자를 입력하세요',
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF6C72CB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Color(0xFF6C72CB), width: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_guessController.text.length == 4) {
                        _submitGuess(_guessController.text);
                        _guessController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  GuessResult _checkGuess(String guess) {
    int strikes = 0;
    int balls = 0;

    for (int i = 0; i < 4; i++) {
      if (guess[i] == _answer![i]) {
        strikes++;
      } else if (_answer!.contains(guess[i])) {
        balls++;
      }
    }

    return GuessResult(strikes, balls);
  }

  void _showCongratulationsDialog(String playerName, int remainingTime) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
                  ),
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '축하합니다! 🎉',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C72CB),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$playerName님이 정답을 맞추셨습니다!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '남은 시간: ${remainingTime ~/ 60}분 ${remainingTime % 60}초',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '확인',
              style: TextStyle(
                color: Color(0xFF6C72CB),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GuessRecord {
  final String playerId;
  final String playerName;
  final String guess;
  final int strikes;
  final int balls;
  final int timestamp;

  GuessRecord({
    required this.playerId,
    required this.playerName,
    required this.guess,
    required this.strikes,
    required this.balls,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'playerId': playerId,
        'playerName': playerName,
        'guess': guess,
        'strikes': strikes,
        'balls': balls,
        'timestamp': timestamp,
      };

  factory GuessRecord.fromMap(Map map) => GuessRecord(
        playerId: map['playerId'],
        playerName: map['playerName'],
        guess: map['guess'],
        strikes: map['strikes'],
        balls: map['balls'],
        timestamp: map['timestamp'],
      );

  @override
  String toString() {
    return 'GuessRecord{playerId: $playerId, playerName: $playerName, guess: $guess, strikes: $strikes, balls: $balls, timestamp: $timestamp}';
  }
}
