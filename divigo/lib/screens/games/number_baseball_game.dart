import 'package:divigo/common/utils/admobUtil.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/screens/lottery/scratch_lottery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:divigo/core/localization/app_localization.dart';

class NumberBaseballGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF6C72CB)),
        title: Text(
          local.get('numberBaseBall'),
          style: TextStyle(
            color: Color(0xFF6C72CB),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SinglePlayerGame(),
    );
  }
}

// 기존 싱글플레이 게임을 별도 위젯으로 분리
class SinglePlayerGame extends StatefulWidget {
  @override
  _SinglePlayerGameState createState() => _SinglePlayerGameState();
}

class _SinglePlayerGameState extends State<SinglePlayerGame> {
  List<TextEditingController> digitControllers =
      List.generate(3, (_) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(3, (_) => FocusNode());
  List<int> answer = [];
  List<String> gameHistory = [];
  bool isGameOver = false;
  bool isGameStarted = false;
  final int maxAttempts = 10; // 최대 도전 횟수 추가
  int currentAttempt = 0; // 현재 도전 횟수 추가

  @override
  void initState() {
    super.initState();
    _generateAnswer(3);
  }

  void _generateAnswer(int digits) {
    var numbers = List<int>.generate(10, (i) => i)..shuffle();
    answer = numbers.take(digits).toList();
    print('New Answer: ${answer.join()}'); // 디버깅용
  }

  @override
  void dispose() {
    digitControllers.forEach((c) => c.dispose());
    focusNodes.forEach((n) => n.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C72CB),
              Color(0xFFCB69C1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 24),
              // 규칙 설명을 최상단으로 이동
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  local.get('strikeRule') + '\n' + local.get('ballRule'),
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Game Content
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
                  child: _buildGameBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameBody() {
    final local = AppLocalization.of(context);
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Game Box (Rules or History)
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6C72CB).withOpacity(0.1),
                    Color(0xFFCB69C1).withOpacity(0.1)
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF6C72CB).withOpacity(0.2),
                ),
              ),
              child: !isGameStarted ? _buildGameRules() : _buildGameHistory(),
            ),
          ),
          SizedBox(height: 12),
          // Number Input Boxes
          if (isGameStarted)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: _buildDigitInput(index),
                ),
              ),
            ),
          SizedBox(height: 12),
          // Keypad
          if (isGameStarted && !isGameOver)
            _buildKeypad()
          else
            // Game Control Button
            Container(
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
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: isGameOver ? _resetGame : _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isGameOver ? local.get('newGame') : local.get('startGame'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGameRules() {
    final local = AppLocalization.of(context);
    return Column(
      children: [
        Text(
          local.get('gameRules'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C72CB),
          ),
        ),
        SizedBox(height: 8),
        Text(
          local.get('strikeRule') + '\n' + local.get('ballRule'),
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGameHistory() {
    final local = AppLocalization.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              local.get('gameHistory'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C72CB),
              ),
            ),
            Text(
              local
                  .get('attemptCount')
                  .replaceAll('%s', currentAttempt.toString())
                  .replaceAll('%d', maxAttempts.toString()),
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6C72CB),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Expanded(
          child: gameHistory.isEmpty
              ? Center(
                  child: Text(
                    local.get('enterNumber'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: gameHistory.map((history) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          history,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            color: history.contains(
                                    local.get('congratulations').split('%s')[0])
                                ? Color(0xFF6C72CB)
                                : Colors.black87,
                            fontWeight: history.contains(
                                    local.get('congratulations').split('%s')[0])
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDigitInput(int index) {
    return Container(
      width: 45,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF6C72CB).withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          digitControllers[index].text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C72CB),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final local = AppLocalization.of(context);
    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...[1, 2, 3, 4, 5]
                  .map((number) => _buildKeypadButton(number))
                  .toList(),
              _buildKeypadButton(-1, icon: Icons.backspace_outlined),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...[6, 7, 8, 9, 0]
                  .map((number) => _buildKeypadButton(number))
                  .toList(),
              _buildKeypadButton(-2, text: local.get('confirm')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(int number, {IconData? icon, String? text}) {
    final local = AppLocalization.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      width: 40,
      height: 32,
      child: ElevatedButton(
        onPressed: () {
          if (number == -1) {
            _handleBackspace();
          } else if (number == -2) {
            _checkGuess();
          } else {
            _handleNumberInput(number);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: number == -2 ? Color(0xFF6C72CB) : Colors.white,
          foregroundColor: number == -2 ? Colors.white : Color(0xFF6C72CB),
          elevation: 1,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Color(0xFF6C72CB).withOpacity(0.2),
            ),
          ),
        ),
        child: icon != null
            ? Icon(icon, size: 14)
            : text != null
                ? Text(text, style: TextStyle(fontSize: 12))
                : Text(
                    number.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
      ),
    );
  }

  void _handleNumberInput(int number) {
    for (int i = 0; i < 3; i++) {
      if (digitControllers[i].text.isEmpty) {
        setState(() {
          digitControllers[i].text = number.toString();
        });
        break;
      }
    }
  }

  void _handleBackspace() {
    setState(() {
      for (int i = 2; i >= 0; i--) {
        if (digitControllers[i].text.isNotEmpty) {
          digitControllers[i].clear();
          break;
        }
      }
    });
  }

  void _checkGuess() async {
    final local = AppLocalization.of(context);
    String guess = digitControllers.map((c) => c.text).join();

    if (guess.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.get('enterAllDigits'))),
      );
      return;
    }

    List<int> guessNumbers = guess.split('').map(int.parse).toList();

    if (guessNumbers.toSet().length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(local.get('enterUniqueDigits'))),
      );
      return;
    }

    int strikes = 0;
    int balls = 0;

    for (int i = 0; i < 3; i++) {
      if (guessNumbers[i] == answer[i]) {
        strikes++;
      } else if (answer.contains(guessNumbers[i])) {
        balls++;
      }
    }

    String resultEmoji = '';
    if (strikes > 0) resultEmoji += '🎯 × $strikes  ';
    if (balls > 0) resultEmoji += '⚾ × $balls  ';
    if (strikes == 0 && balls == 0) resultEmoji = '❌ OUT!  ';

    String resultMessage = local
        .get('resultFormat')
        .replaceAll('%b', guess)
        .replaceAll('%a', resultEmoji);

    setState(() {
      currentAttempt++;
      gameHistory.insert(0, resultMessage);

      if (strikes == 3) {
        isGameOver = true;
        gameHistory.insert(
            0, local.get('congratulations').replaceAll('%s', guess));
      } else if (currentAttempt >= maxAttempts) {
        isGameOver = true;
        gameHistory.insert(
            0, local.get('gameOver').replaceAll('%s', answer.join()));
      }

      digitControllers.forEach((controller) => controller.clear());
      if (!isGameOver) {
        focusNodes.first.requestFocus();
      }
    });

    if (strikes == 3) {
      AdmobUtil.instance.showInterstitialAd();

      var params = {
        'category': 'numberBaseball',
        'type': 'charge',
        'count': 1,
        'subject': 'number baseball game',
        'comment': 'number baseball game',
      };

      var res =
          await httpPost(path: '/member/updateLotteryCount', params: params);

      if (res['code'] == 200) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ScratchLotteryScreen()));
      }
    }
  }

  void _startGame() {
    setState(() {
      isGameStarted = true;
      isGameOver = false;
      currentAttempt = 0; // 도전 횟수 초기화
      gameHistory.clear();
      _generateAnswer(3);
    });
  }

  void _resetGame() {
    setState(() {
      isGameStarted = false;
      isGameOver = false;
      currentAttempt = 0; // 도전 횟수 초기화
      gameHistory.clear();
      digitControllers.forEach((controller) => controller.clear());
    });
  }
}
