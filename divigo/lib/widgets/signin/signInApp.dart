import 'dart:convert';
import 'dart:developer';
import 'package:divigo/common/utils/deviceInfo.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/screens/home/home_screen.dart';
import 'package:divigo/screens/signin/siginup_screen.dart';
import 'package:divigo/screens/wallet/wallet_screen.dart';
import 'package:divigo/widgets/signin/signInWithApple.dart';
import 'package:divigo/widgets/signin/signInWithGoogle.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Map<String, dynamic>?> signInApp(context, String joinType) async {
  //로그인

  var info = await deviceInfo();

  if (joinType == 'google') {
    try{
      var res = await signInWithGoogle();

      if (res != null && res.user != null) {
        return checkJoinPlatform(
            context,
            res.user?.providerData[0].uid,
            res.user?.providerData[0].email,
            info['id'],
            info['platform'],
            'google');
      }
    }catch(e){
      return null;
    }

  } else if (joinType == 'apple') {
    try{
      var res = await signInWithApple();

      if (res != null && res.user != null) {
        log('data : ${res.user?.providerData[0]}');
        return checkJoinPlatform(
            context,
            res.user?.providerData[0].uid,
            res.user?.providerData[0].email,
            info['id'],
            info['platform'],
            'apple');
      }
    }catch(e){
      return null;
    }

  } else if (joinType == 'demo') {
    await registDevice();
    return checkJoinPlatform(
        context, 'demo', 'demo@email.com', info['id'], 'aos', 'apple');
  }
  return null;
}

Future<Map<String, dynamic>?> checkJoinPlatform(
    context, uid, email, deviceId, joinPlatform, joinType) async {
  var exist = await httpPost(
      path: '/member/checkJoinedPlatformKey', params: {'platformKey': uid});

  if (exist['code'] == 404) {
    //신규회원
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SignupScreen(
                joinPlatform: joinPlatform,
                joinType: joinType,
                platformKey: uid,
                platformEmail: email,
                deviceId: deviceId)));
  } else {
    //기존회원

    var res = await httpPost(
        path: '/member/loginByPlatform',
        params: {'platformKey': uid, 'device': deviceId});

    log('checkJoinPlatform기존회원');
    log(res.toString());

    if (res != null) {
      if (res['code'] == 200) {
        //정상

        log(res['result']['token']);
        const storage = FlutterSecureStorage();
        await storage.write(key: 'user', value: jsonEncode(res['result']));
        await storage.write(key: 'token', value: res['result']['token']);
        await storage.write(
            key: 'refreshToken', value: res['result']['refreshToken']);

        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => const HomeScreen()));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else if (res['code'] == 510) {
        //탈퇴대기
        return {
          'code': 510,
          'platformKey': uid,
          'email': email,
          'deviceId': deviceId,
          'joinPlatform': joinPlatform,
          'joinType': joinType
        };
      } else if (res['code'] == 505) {
        //정지
        return {'code': 505};
      }
    }
  }
  return null;
}

Future<void> registDevice() async {
  final info = await deviceInfo();
  final id = info['id'];
  final device = await httpGetWithCode(path: '/device?deviceId=$id');

  if (device == null) {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final params = {'deviceId': id, 'pushId': fcmToken};

    await httpPost(path: '/device', params: params);
  }
}
