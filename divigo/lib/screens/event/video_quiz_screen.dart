import 'package:divigo/screens/event/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoQuizScreen extends StatefulWidget {
  @override
  _VideoQuizScreenState createState() => _VideoQuizScreenState();
}

class _VideoQuizScreenState extends State<VideoQuizScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://cdn.prnumber.com/2025/03/07/1741323828531_776815.mp4'),
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(_onVideoFinished);
      });
  }

  void _onVideoFinished() {
    if (_controller.value.position >= _controller.value.duration) {
      _showQuiz();
    }
  }

  void _showQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
