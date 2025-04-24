import 'dart:developer';
import 'package:divcow/bottom_tab_navigation.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/deviceInfo.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/splash/actions/appVersionCheck.dart';
import 'package:divcow/splash/actions/registDevice.dart';
import 'package:divcow/common/utils/session.dart';
import 'package:divcow/splash/actions/signInApp.dart';
import 'package:divcow/splash/components/elective_update_box.dart';
import 'package:divcow/splash/components/login_box.dart';
import 'package:divcow/splash/components/network_box.dart';
import 'package:divcow/splash/components/reject_box.dart';
import 'package:divcow/splash/components/required_update_box.dart';
import 'package:divcow/splash/components/waiting_leave_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late bool elective = false;
  late bool require = false;
  late bool network = false;
  late bool login = false;
  late bool waitingLeave = false;
  late bool reject = false;

  late Map<String, dynamic> _snsRes = {};
  
  @override
  void initState() {
    super.initState();
    customInit();
  }

  void customInit() async {

    //login test
    // const storage = FlutterSecureStorage();
    // await storage.deleteAll();
    await registDevice();
    var versionCheck = await appVersionCheck();
    if(versionCheck == 'require') {
      setState(() {
        require = true;
      });
    } else if(versionCheck == 'elective') {
      setState(() {
        elective = true;
      });
    } else {
      loginCheck();
    }
  }

  loginCheck() async {
    bool chk = await sessionCheck();
    if(chk) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Bottomtabnavigation()));
    } else {
      setState(() {
        login = true;
      });
    }
  }

  void changeElective(bool click) async { //선택 업데이트
    if(click) {
      //@TODO:: 스토어로 이동
      redirectStore();
    } else {
      setState(() {
        elective = false;
      });
      loginCheck();
    }
  }

  void clickRequired(bool click) async { //강제 업데이트
    redirectStore();
  }

  void clickNetwork(bool click) { //인터넷 접속 불가
    //@TODO::인터넷 접속 불가시 처리
  }

  void clickWaitingLeave(bool click) async { //탈퇴대기회원
    
    log('clickwaiting');
    log(_snsRes.toString());


    if(click) {
      var res = await httpPost(path: '/member/withdrawalCancel', params: {'platformKey': _snsRes['platformKey']});
      if(res['code'] == 200) {
        await checkJoinPlatform(context, _snsRes['platformKey'], _snsRes['email'], _snsRes['deviceId'], _snsRes['joinPlatform'], _snsRes['joinType']);
      }
    } else {
      setState(() {
        waitingLeave = false;
        login = true;
      });
    }
    
  }

  void clickReject(bool click) { //정지회원 앱 종료
    setState(() {
      reject = false;
      login = true;
    });
  }

  void redirectStore() async {
    final device = await deviceInfo();
    if(device['platform'] == 'aos') {
      Uri storeUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.root37.divcow');
      if(await canLaunchUrl(storeUrl)) {
        await launchUrl(storeUrl);
      }
    } else if(device['platform'] == 'ios') {
      Uri storeUrl = Uri.parse('https://apps.apple.com/us/app/id6739669351');
      if(await canLaunchUrl(storeUrl)) {
        await launchUrl(storeUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return SafeArea(
      child: Scaffold(
        backgroundColor: DivcowColor.background,
        body:
          Stack(
            children: [
              Center(
                child: Image.asset('assets/images/splash_logo.png'),
              ),
              elective ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  electiveUpdateBox(changeElective)
                ],
              ) : const SizedBox.shrink(),
              require ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  requiredUpdateBox(clickRequired)
                ],
              ) : const SizedBox.shrink(),
              network ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  networkBox(clickNetwork)
                ],
              ) : const SizedBox.shrink(),
              login ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  loginBox((joinType) async {
                    var res = await signInApp(context, joinType);

                    log('sigininapp로그인완료response');
                    log(res.toString());

                    if(res != null) {
                      if(res['code'] == 510) {
                        _snsRes = res;

                        log(_snsRes.toString());
                        setState(() {
                          login = false;
                          waitingLeave = true;
                        });
                      } else if(res['code'] == 505) {
                        setState(() {
                          login = false;
                          reject = true;
                        });
                      }
                    }
                  })
                ],
              ) : const SizedBox.shrink(),
              waitingLeave ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  watingLeaveBox(clickWaitingLeave)
                ],
              ) : const SizedBox.shrink(),
              reject ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  rejectBox(clickReject)
                ],
              ) : const SizedBox.shrink(),
            ],
          )
      )
    );
  }
}