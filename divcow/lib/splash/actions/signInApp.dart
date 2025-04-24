import 'dart:convert';
import 'dart:developer';
import 'package:divcow/bottom_tab_navigation.dart';
import 'package:divcow/common/utils/deviceInfo.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/common/utils/signInWithApple.dart';
import 'package:divcow/common/utils/signInWithGoogle.dart';
import 'package:divcow/signup/screens/siginup_screen.dart';
import 'package:divcow/splash/actions/registDevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';


Future<Map<String, dynamic>?> signInApp(context, String joinType) async { //로그인

  var info = await deviceInfo();

  if(joinType == 'google') {
    var res = await signInWithGoogle();

    if(res != null && res.user != null) {
      return checkJoinPlatform(context, res.user?.providerData[0].uid, res.user?.providerData[0].email, info['id'], info['platform'], 'google');
    }
  
  } else if(joinType == 'apple') { 

    var res = await signInWithApple();

    if(res != null && res.user != null) {
      return checkJoinPlatform(context, res.user?.providerData[0].uid, res.user?.providerData[0].email, info['id'], info['platform'], 'apple');
    }
  } else if(joinType == 'demo') { 
    await registDevice();
    return checkJoinPlatform(context, 'demo', 'demo@email.com', info['id'], 'aos', 'apple');

  }
  return null;
    
}

Future<Map<String, dynamic>?> checkJoinPlatform(context, uid, email, deviceId, joinPlatform, joinType) async {
  
  var exist = await httpPost(path: '/member/checkJoinedPlatformKey', params: {'platformKey': uid});

  if(exist['code'] == 404) { //신규회원
    Navigator.pushReplacement(context, 
      MaterialPageRoute( builder: (context) => 
        SignupScreen(
          joinPlatform: joinPlatform, 
          joinType: joinType, 
          platformKey: uid, 
          platformEmail: email, 
          deviceId: deviceId
        )
      )
    ); 

  } else { //기존회원

    var res = await httpPost(path: '/member/loginByPlatform', params: {'platformKey': uid, 'device': deviceId});

    log('checkJoinPlatform기존회원');
    log(res.toString());

    if(res != null) {
      if(res['code'] == 200) { //정상

        log(res['result']['token']);
        const storage = FlutterSecureStorage();
        await storage.write(key: 'user', value: jsonEncode(res['result']));
        await storage.write(key: 'token', value: res['result']['token']);
        await storage.write(key: 'refreshToken', value: res['result']['refreshToken']);
        
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Bottomtabnavigation()));  

      } else if(res['code'] == 510){ //탈퇴대기
        return {'code':510, 'platformKey': uid, 'email': email, 'deviceId': deviceId, 'joinPlatform': joinPlatform, 'joinType': joinType};
      } else if(res['code'] == 505) { //정지
        return {'code':505};
      }
      
    }
  }
  return null;
}