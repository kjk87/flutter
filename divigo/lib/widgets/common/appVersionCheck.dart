import 'dart:io';
import 'package:divigo/common/utils/deviceInfo.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String?> appVersionCheck() async {
  var app = await getVersion();

  if (app['isOpen'] == false) return null;

  var appVersion = app['version'].split('.');

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var packageVersion = packageInfo.version.split('.');

  if (int.parse(appVersion[0]) <= int.parse(packageVersion[0])) {
    if (int.parse(appVersion[1]) <= int.parse(packageVersion[1])) {
      if (int.parse(appVersion[2]) <= int.parse(packageVersion[2])) {
        return null;
      }
    }
  }

  if (app['isVital'] == true) {
    return 'require';
  } else {
    return 'elective';
  }
}

getVersion() async {
  var device = await deviceInfo();
  if (device == null) exit(0); //디바이스 정보 없을 시 앱 종료

  var platform = device['platform'];
  var app = await httpGetWithCode(
      path: '/app?status=active&platform=$platform'); //앱 버전 가져오기
  if (app == null) exit(0); // db에 등록된 버전 없을 시 앱 종료

  return app;
}
