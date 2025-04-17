import 'dart:developer';
import 'dart:io';

import 'package:divigo/models/member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../../screens/splash/splash_screen.dart';
import 'http.dart';

const host = 'https://api.divcow.com/api';
const apiKey = 'cw1pgqa2k6mea3zc';

Future<String?> getToken() async {
  const storage = FlutterSecureStorage();
  var token = await storage.read(key: 'token');
  return token;
}

Future<Member?> getUser(BuildContext context) async {
  await reloadSession(context);
  const storage = FlutterSecureStorage();
  var userStr = await storage.read(key: 'user');
  if (userStr != null) {
    return Member.fromJson(jsonDecode(userStr));
  }
  return null;
}

reloadSession(BuildContext context) async {
  const storage = FlutterSecureStorage();
  var res = await httpPost(path: '/member/reloadSession');

  if (res['code'] != 200) {
    var refresh = await httpPost(path: '/member/refreshToken');

    if (refresh['code'] != 200) {
      //리프레시토큰만료
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false);
    } else {
      var token = refresh['result'];
      await storage.write(key: 'token', value: token.toString());
      var res = await httpPost(path: '/member/reloadSession');
      if (res['code'] != 200) {
        const storage = FlutterSecureStorage();
        await storage.deleteAll();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
              (route) => false,
        );
      }else{
        await storage.write(key: 'user', value: jsonEncode(res['result']));
      }
      // await storage.write(key: 'token', value: res['result']['token']);
    }
  } else {
    await storage.write(key: 'user', value: jsonEncode(res['result']));
    // await storage.write(key: 'token', value: res['result']['token']);
  }
}
