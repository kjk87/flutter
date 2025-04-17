import 'package:divigo/screens/event/event_detail_screen.dart';
import 'package:divigo/screens/event/event_self_brand_basic_screen.dart';
import 'package:divigo/screens/event/video_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:divigo/services/self_brand_service.dart';

class DialPadScreen extends StatefulWidget {
  const DialPadScreen({Key? key}) : super(key: key);

  @override
  _DialPadScreenState createState() => _DialPadScreenState();
}

class _DialPadScreenState extends State<DialPadScreen> {
  String phoneNumber = '';

  void addNumber(String number) {
    setState(() {
      phoneNumber += number;
    });
  }

  void deleteNumber() {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      });
    }
  }

  void _handleSubmit() {
    if (phoneNumber.isEmpty) return;

    // 프로필이 존재하는지 확인
    final profile = SelfBrandService.getProfile(phoneNumber);
    if (profile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventSelfBrandBasicScreen(
            phoneNumber: phoneNumber,
          ),
        ),
      );
    } else {
      // 프로필이 없는 경우 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('존재하지 않는 번호입니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('다이얼 패드'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 상단 전화번호 표시 영역
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        phoneNumber.isEmpty ? '전화번호를 입력하세요' : phoneNumber,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color:
                              phoneNumber.isEmpty ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1),
                // 다이얼 패드 영역
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildDialPadRow(['1', '2', '3']),
                        const SizedBox(height: 8),
                        buildDialPadRow(['4', '5', '6']),
                        const SizedBox(height: 8),
                        buildDialPadRow(['7', '8', '9']),
                        const SizedBox(height: 8),
                        buildDialPadRow(['*', '0', '#']),
                        const SizedBox(height: 8),
                        // 최하단 버튼들
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 첫 번째 위치 (빈 공간)
                            Container(
                              width: 70,
                              height: 70,
                            ),
                            // GO 버튼 (중앙 위치)
                            GestureDetector(
                              onTap: _handleSubmit,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: const Center(
                                  child: Text(
                                    "GO",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // 삭제 버튼 (오른쪽 위치)
                            GestureDetector(
                              onTap: deleteNumber,
                              onLongPress: () {
                                setState(() {
                                  phoneNumber = '';
                                });
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade200,
                                ),
                                child: const Icon(
                                  Icons.backspace,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDialPadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        return GestureDetector(
          onTap: () => addNumber(number),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
