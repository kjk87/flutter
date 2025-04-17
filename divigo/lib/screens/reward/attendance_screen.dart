import 'package:divigo/common/utils/http.dart';
import 'package:divigo/common/utils/loginInfo.dart';
import 'package:divigo/models/member.dart';
import 'package:divigo/screens/reward/attendance_scratch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/localization/app_localization.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Future<Member?> futureUser;
  bool _isLoading = false;
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    futureUser = _fetchData();
  }

  Future<Member?> _fetchData() async {
    final member = await getUser(context);
    isAvailable = await httpGetWithCode(path: '/member/attendance/check');
    return member;
  }

  final String _stampSvg = '''
    <svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <!-- 배경 원 -->
      <circle cx="50" cy="50" r="45" fill="#FF5252" fill-opacity="0.9"/>
      
      <!-- 꽃잎 -->
      <path d="
        M50 10 
        C60 25, 75 25, 90 50
        C75 75, 60 75, 50 90
        C40 75, 25 75, 10 50
        C25 25, 40 25, 50 10
        Z" 
        fill="none" 
        stroke="white" 
        stroke-width="2"
      />
      
      <!-- 내부 꽃잎 -->
      <path d="
        M50 20
        C57 30, 70 30, 80 50
        C70 70, 57 70, 50 80
        C43 70, 30 70, 20 50
        C30 30, 43 30, 50 20
        Z" 
        fill="white" 
        fill-opacity="0.3"
      />
      
      <!-- 중앙 원 -->
      <circle cx="50" cy="50" r="10" fill="white" fill-opacity="0.6"/>
      
      <!-- 체크 표시 -->
      <path d="M35 50 L45 60 L65 40" 
        stroke="white" 
        stroke-width="3" 
        stroke-linecap="round" 
        fill="none"
      />
    </svg>
  ''';

  void _showAttendanceCompleteDialog(BuildContext context, int count) {
    final local = AppLocalization.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle,
                color: Color(0xFF6C72CB),
                size: 28),
            SizedBox(width: 8),
            Text(local.get('attendanceComplete')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              child: SvgPicture.string(
                _stampSvg,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),
            Text(
              local.get('attendanceCompleteDesc'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              local.get('attendanceCompleteReward').replaceAll('%s', count.toString()),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              local.get('confirm'),
              style: TextStyle(
                color: Color(0xFF6C72CB),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                futureUser = _fetchData(); // 출석체크 후 데이터 새로고침
              });
            },
          ),
        ],
      ),
    );
  }

  void _handleDayTap(int day) async {
    if (isAvailable) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await httpPost(path: '/member/attendance');
        int count = response['result'];

        setState(() {
          futureUser = _fetchData();
          _isLoading = false;
        });

        _showAttendanceCompleteDialog(context, count);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalization.of(context).get('attendanceError'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);

    return FutureBuilder<Member?>(
      future: futureUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF6C72CB)),
              title: Text(
                local.get('attendance'),
                style: const TextStyle(
                  color: Color(0xFF6C72CB),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF6C72CB)),
              title: Text(
                local.get('attendance'),
                style: const TextStyle(
                  color: Color(0xFF6C72CB),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalization.of(context).get('loadingError'),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureUser = _fetchData();
                      });
                    },
                    child: Text(AppLocalization.of(context).get('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        final now = DateTime.now();
        final days = 28;
        final attendanceCount = snapshot.data?.attendanceCount ?? 0;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: Color(0xFF6C72CB)),
                title: Text(
                  local.get('attendance'),
                  style: const TextStyle(
                    color: Color(0xFF6C72CB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // 상단 배너
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6C72CB),
                            Color(0xFFCB69C1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6C72CB).withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$attendanceCount / ${days}days',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 달력 그리드
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: days,
                        itemBuilder: (context, index) {
                          final day = index + 1;
                          final isChecked = day <= attendanceCount;

                          return GestureDetector(
                            onTap: isAvailable ? () => _handleDayTap(day) : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                  Colors.grey[200]!,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      day.toString(),
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isChecked)
                                    Positioned.fill(
                                      child: SvgPicture.string(
                                        _stampSvg,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // 출석체크 버튼
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (!isAvailable || _isLoading)
                              ? null
                              : () async {
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              final response = await httpPost(path: '/member/attendance');
                              int count = response['result'];

                              setState(() {
                                _isLoading = false;
                              });

                              _showAttendanceCompleteDialog(context, count);
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalization.of(context).get('attendanceError'))),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            backgroundColor: Color(0xFF6C72CB),
                            foregroundColor: Colors.white,
                          ),
                          child: _isLoading
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(
                            !isAvailable
                                ? local.get('alreadyChecked')
                                : local.get('checkAttendance'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 하단 설명
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            local.get('howToAttend'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildGuideItem(
                            icon: Icons.touch_app,
                            title: local.get('clickToAttend'),
                            description: local.get('clickToAttendDesc'),
                          ),
                          const SizedBox(height: 12),
                          _buildGuideItem(
                            icon: Icons.calendar_today,
                            title: local.get('dailyAttendance'),
                            description: local.get('dailyAttendanceDesc'),
                          ),
                          const SizedBox(height: 12),
                          _buildGuideItem(
                            icon: Icons.card_giftcard,
                            title: local.get('attendanceRewards'),
                            description: local.get('attendanceRewardsDesc'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C72CB)),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Color 확장 메서드 추가
extension ColorExtension on Color {
  String toHex() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }
}