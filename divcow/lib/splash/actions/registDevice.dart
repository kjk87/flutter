import 'package:divcow/common/utils/deviceInfo.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


  Future<void> registDevice() async {

    final info = await deviceInfo();
    final id = info['id'];
    final device = await httpGetWithCode(path: '/device?deviceId=$id');

    if(device == null) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final params = {
        'deviceId': id,
        'pushId': fcmToken
      };

      await httpPost(path: '/device', params: params);
    }
    
  }