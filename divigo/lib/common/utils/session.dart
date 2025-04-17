import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'http.dart';

Future<bool> sessionCheck() async {
  const storage = FlutterSecureStorage();
  
  final token = await storage.read(key: 'token');

  if(token == null) {
    return false;
  }

  var userResult = await httpPost(path: '/member/reloadSession');

  if(userResult['code'] != 200) { //토큰만료
    var refresh = await httpPost(path: '/member/refreshToken');
    if(refresh['code'] != 200) { //리프레시토큰만료
      return false;
    } else {
      var token = refresh['result'];
      await storage.write(key: 'token', value: token.toString());
      var userResult = await httpPost(path: '/member/reloadSession');
      await storage.write(key: 'user', value: jsonEncode(userResult['result']));
      return true;
    }
  } else {
    await storage.write(key: 'user', value: jsonEncode(userResult['result']));
    return true;
  }

}