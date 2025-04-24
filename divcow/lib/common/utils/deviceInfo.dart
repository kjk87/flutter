import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

Future deviceInfo() async {

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
        AndroidDeviceInfo info = await deviceInfo.androidInfo;
        return {'platform': 'aos', 'id': info.id};
    } else if (Platform.isIOS) {
        IosDeviceInfo info = await deviceInfo.iosInfo;
        return {'platform': 'ios', 'id': info.identifierForVendor};
    } else if (Platform.isLinux) {
      final linuxInfo = await deviceInfo.linuxInfo;
      return {'platform': 'linux', 'id': linuxInfo.machineId};
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      return {'platform': 'windows', 'id': windowsInfo.deviceId};
    } else if (Platform.isMacOS) {
      final macOsInfo = await deviceInfo.macOsInfo;
      return {'platform': 'mac', 'id': macOsInfo.systemGUID};
    }

    return null;
}