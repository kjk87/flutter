import 'package:flutter/material.dart';
import 'package:divigo/core/localization/app_localization.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? _selectedAnswer;
  bool _isLoading = false;
  late List<String> _answers;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _answers = [
      AppLocalization.of(context).get('event_quiz_answer_1'),
      AppLocalization.of(context).get('event_quiz_answer_2'),
      AppLocalization.of(context).get('event_quiz_answer_3'),
      AppLocalization.of(context).get('event_quiz_answer_4'),
    ];
  }

  Future<void> _checkAnswer() async {
    if (_selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalization.of(context).get('event_quiz_select_answer'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // final response = await httpPost(
      //   path: '/videoQuiz',
      //   params: {'answer': _selectedAnswer},
      // );

      if (_selectedAnswer ==
          AppLocalization.of(context).get('event_quiz_answer_2')) {
        _showSuccessDialog(10);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalization.of(context).get('event_quiz_wrong_answer')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalization.of(context).get('event_quiz_error'))),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(int points) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title:
            Text(AppLocalization.of(context).get('event_quiz_correct_answer')),
        content: Text(
            '${AppLocalization.of(context).get('event_quiz_points')} ${points}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              Navigator.of(context).pop(); // 퀴즈 화면 닫기
              Navigator.of(context).pop(); // 비디오 화면 닫기
            },
            child: Text(AppLocalization.of(context).get('event_quiz_confirm')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).get('event_quiz_title')),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalization.of(context).get('event_quiz_question'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            ...List.generate(
              _answers.length,
              (index) => RadioListTile<String>(
                title: Text(_answers[index]),
                value: _answers[index],
                groupValue: _selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    _selectedAnswer = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C72CB),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      AppLocalization.of(context).get('event_quiz_confirm'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
