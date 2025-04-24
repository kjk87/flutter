import 'dart:developer';
import 'dart:io';

import 'package:divcow/common/utils/http.dart';
import 'package:divcow/splash/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

const host = 'https://api.divcow.com/api';
const apiKey = 'cw1pgqa2k6mea3zc';

Future<String?> getToken() async {
  const storage = FlutterSecureStorage();
  var token = await storage.read(key: 'token');
  return token;
}

Future<dynamic> getUser(BuildContext context) async {
  await reloadSession(context);
  const storage = FlutterSecureStorage();
  var userStr = await storage.read(key: 'user');
  if(userStr != null){
    return jsonDecode(userStr);
  }
  return null;
}

reloadSession(BuildContext context) async {
  const storage = FlutterSecureStorage();
  var res = await httpPost(path: '/member/reloadSession');

  log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>reloadSession');
  log(res.toString());
  if(res['code'] != 200) {

    print('<<<<<<<<<<<<<<<<<<<<<<<11111111111');
    var refresh = await httpPost(path: '/member/refreshToken');

    print ('<<<<<<<<<<<<<<<<<<<<<<<222222222222');
    log(refresh.toString());
    if(refresh['code'] != 200) { //리프레시토큰만료
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
    } else {
      var token = refresh['result'];
      await storage.write(key: 'token', value: token.toString());
      var res = await httpPost(path: '/member/reloadSession');
      await storage.write(key: 'user', value: jsonEncode(res['result']));
      // await storage.write(key: 'token', value: res['result']['token']);
    }
  }else{
    log('<<<<<<<<<<<<<<<<<<<<<<<333333333333333');
    await storage.write(key: 'user', value: jsonEncode(res['result']));
    // await storage.write(key: 'token', value: res['result']['token']);
  }

}