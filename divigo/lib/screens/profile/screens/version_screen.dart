import 'package:divigo/common/utils/http.dart';
import 'package:divigo/core/localization/app_localization.dart';
import 'package:divigo/widgets/common/appVersionCheck.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionScreen extends StatefulWidget {
  const VersionScreen({super.key});

  @override
  State<VersionScreen> createState() => _VersionScreenState();
}

class _VersionScreenState extends State<VersionScreen> {
  Future<Map<String, dynamic>> versionInfo = Future.value({});
  String currentVersion = '';
  String latestVersion = '';
  bool isLatest = true;
  String? updateStatus; // 'require', 'elective', null(최신버전)

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    // 현재 앱 버전 가져오기
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      currentVersion = packageInfo.version;
    });

    try {
      // appVersionCheck.dart의 getVersion() 함수 사용
      final app = await getVersion();

      // 버전 비교 로직 (appVersionCheck 함수 참고)
      final appVersion = app['version'].toString().split('.');
      final packageVersion = currentVersion.split('.');

      // 배열 길이 맞추기
      while (appVersion.length < 3) appVersion.add('0');
      while (packageVersion.length < 3) packageVersion.add('0');

      bool needsUpdate = false;

      if (int.parse(appVersion[0]) > int.parse(packageVersion[0])) {
        needsUpdate = true;
      } else if (int.parse(appVersion[0]) == int.parse(packageVersion[0])) {
        if (int.parse(appVersion[1]) > int.parse(packageVersion[1])) {
          needsUpdate = true;
        } else if (int.parse(appVersion[1]) == int.parse(packageVersion[1])) {
          if (appVersion.length > 2 && packageVersion.length > 2) {
            if (int.parse(appVersion[2]) > int.parse(packageVersion[2])) {
              needsUpdate = true;
            }
          }
        }
      }

      setState(() {
        versionInfo = Future.value(app);
        latestVersion = app['version'].toString();
        isLatest = !needsUpdate;

        // 업데이트 상태 설정
        if (needsUpdate) {
          updateStatus = app['isVital'] == true ? 'require' : 'elective';
        } else {
          updateStatus = null; // 최신 버전
        }
      });
    } catch (e) {
      print('버전 정보 로드 오류: $e');
      setState(() {
        versionInfo = Future.error(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).get('version'),
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF333333),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: versionInfo,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 현재 버전 정보 카드
                    _buildVersionCard(
                      title: AppLocalization.of(context).get('currentVersion'),
                      version: currentVersion,
                      isCurrentVersion: true,
                    ),
                    const SizedBox(height: 16),

                    // 최신 버전 정보 카드
                    _buildVersionCard(
                      title: AppLocalization.of(context).get('latestVersion'),
                      version: latestVersion,
                      isCurrentVersion: false,
                    ),
                    const SizedBox(height: 24),

                    // 업데이트 상태 및 버튼
                    _buildUpdateSection(data),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalization.of(context).get('notFoundVersion'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C72CB)),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildVersionCard({
    required String title,
    required String version,
    required bool isCurrentVersion,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isCurrentVersion ? Icons.phone_android : Icons.system_update,
              color: const Color(0xFF6C72CB),
              size: 24,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  version,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateSection(Map<String, dynamic> data) {
    final String storeUrl = data['storeUrl'] ?? '';

    // 업데이트 상태에 따른 색상 및 메시지 설정
    Color statusColor;
    String statusMessage;
    String? detailMessage;
    IconData statusIcon;

    if (updateStatus == 'require') {
      statusColor = Colors.red;
      statusMessage = AppLocalization.of(context).get('needMustUpdate');
      detailMessage = AppLocalization.of(context).get('needMustUpdateDesc');
      statusIcon = Icons.error_outline;
    } else if (updateStatus == 'elective') {
      statusColor = const Color(0xFFFF9800);
      statusMessage = AppLocalization.of(context).get('newVersion');
      detailMessage = AppLocalization.of(context).get('newVersionDesc');
      statusIcon = Icons.update;
    } else {
      statusColor = const Color(0xFF6C72CB);
      statusMessage = AppLocalization.of(context).get('nowLatestVersion');
      statusIcon = Icons.check_circle;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 업데이트 상태 표시
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                statusMessage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
              if (detailMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  detailMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),

        // 업데이트 버튼 (최신 버전이 아닐 때만 표시)
        if (updateStatus != null && storeUrl.isNotEmpty) ...[
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _launchURL(storeUrl),
            style: ElevatedButton.styleFrom(
              backgroundColor: updateStatus == 'require'
                  ? Colors.red
                  : const Color(0xFF6C72CB),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(updateStatus == 'require' ? AppLocalization.of(context).get('nowUpdate') : AppLocalization.of(context).get('update')),
          ),
        ],
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
