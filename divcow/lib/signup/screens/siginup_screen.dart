import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:device_region/device_region.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/signup/components/bottom_alert_box.dart';
import 'package:divcow/signup/components/linear_button.dart';
import 'package:divcow/signup/components/nicknamebox.dart';
import 'package:divcow/signup/components/termsbox.dart';
import 'package:divcow/signup/screens/terms_screen.dart';
import 'package:divcow/splash/actions/signInApp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:divcow/signup/components/inputbox.dart';
import 'package:easy_localization/easy_localization.dart';

class SignupScreen extends StatefulWidget {

  final String joinType;
  final String joinPlatform;
  final String platformKey;
  final String? platformEmail;
  final String deviceId;

  const SignupScreen({super.key, required this.joinType, required this.joinPlatform, required this.platformKey, required this.platformEmail, required this.deviceId});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  late String divcowCode = '';
  late String nickname = '';
  late String email = '';
  late String referralCode = '';
  late List<String> termsNo = [];
  late bool checkAll = false;
  late dynamic nicknameReject = null;
  late dynamic termsList = [];
  
  late bool alertEmail = false;
  late bool alertNickname = false;
  late bool alertTerms = false;
  late bool alertCheckNickname = false;

  final TextEditingController divcowcodeController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referrerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initReferrerDetails();
    getTerms();
  }

  @override
  void dispose() {
    
    divcowcodeController.dispose();
    nicknameController.dispose();
    emailController.dispose();
    referrerController.dispose();

    super.dispose();
  }

  Future<void> initReferrerDetails() async {
    String referrerDetailsString;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ReferrerDetails referrerDetails = await AndroidPlayInstallReferrer.installReferrer;

      referrerDetailsString = referrerDetails.toString();
    } catch (e) {
      referrerDetailsString = 'Failed to get referrer details: $e';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      referralCode = referrerDetailsString;
    });
  }

  Future<void> getTerms() async {

    var res = await httpListWithCode(path: '/terms');
      setState(() {
        termsList = res;
      });
  }

  checkTerms(bool check, String seqNo) {

    if(check) {
      setState(() {
        termsNo.add(seqNo);  
      });
    } else {
      setState(() {
        termsNo.removeWhere((item) => item == seqNo);  
      });
    }

    if(termsList.length > 0 && termsList.length == termsNo.length) {
      setState(() {
        checkAll = true;
      });
    } else {
      setState(() {
        checkAll = false;
      });
    }
  }

  checkAllTerms() {

    if(termsList.length > 0 && termsList.length == termsNo.length) {
      setState(() {
        checkAll = false;
        termsNo = [];
      });
    } else {
      List<String> nos = [];
      for(dynamic terms in termsList) {
        nos.add(terms['seqNo'].toString());
      }
      setState(() {
        checkAll = true;
        termsNo = nos;
      });
    }
  }



  Future<void> signUp() async {

    if(nickname == '') {
      setState(() {
        alertNickname = true;  
      });
      return;
    }

    if(email == '') {
      setState(() {
        alertEmail = true;  
      });
      return;
    }

    if(termsList.length > 0) {
      for(var term in termsList) {
        if(term['compulsory'] == true) {
          if(!termsNo.contains(term['seqNo'].toString())) {
            setState(() {
              alertTerms = true;  
            });
            return;
          }
        }
      }
    }

    if(nicknameReject == null || nicknameReject == true) {
      setState(() {
        alertCheckNickname = true;
      });
      return;
    }

    String? countryCode = await DeviceRegion.getSIMCountryCode();
    countryCode ??= "";
    var languageCode = PlatformDispatcher.instance.locale.languageCode;

    var params = {
      'termsNo': termsNo.join(','),
      'divcowCode': divcowCode,
      'joinType': widget.joinType,
      'joinPlatform': widget.joinPlatform,
      'nation': countryCode,
      'nickname': nickname,
      'email': email,
      'platformKey': widget.platformKey,
      'language': languageCode,
      'platformEmail': widget.platformEmail,
      'device': widget.deviceId
    };

    var joinResult = await httpPost(path: '/member/join2', params: params);
    if(joinResult['code'] == 200) {
      await checkJoinPlatform(context, widget.platformKey, email, widget.deviceId, widget.joinPlatform, widget.joinType);
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(39, 37, 100, 1.0),
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(19),
                            topRight: Radius.circular(19)
                          ),
                          color: DivcowColor.popup
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(tr('Registration'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: DivcowColor.textDefault),),
                            )
                          ),
                          signupInputbox(tr('DivcowCode'), [0, 10, 0, 0], (text) {setState(() {divcowCode = text;});}, null, divcowcodeController),
                          signupNicknamebox(
                            tr('Nickname'),
                            [0, 10, 0, 3],
                            tr('NicknameAvailable'),
                            tr('NicknameUsed'),
                            nicknameReject,
                            (text) {
                              setState(() {nickname = text;});
                              setState(() {nicknameReject = null;});
                            },
                            () async {
                              final res = await httpGetWithCode(path: '/member/checkNickname?nickname=$nickname');
                              if(res) {setState(() { nicknameReject = false; });} 
                              else {setState(() { nicknameReject = true; });}
                            },
                            nicknameController
                          ),
                          signupInputbox(tr('Email'), [0, 10, 0, 0], (text) {setState(() {email = text;});}, null, emailController),
                          signupInputbox(tr('Referralcode'), [0, 10, 0, 0], (text) {setState(() {referralCode = text;});}, tr('ReferralcodeDesc'), referrerController..text = referralCode),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Container(
                              height: 1, 
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [0.0, 1.0],
                                  colors: DivcowColor.linearMain,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(23)),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  checkAllTerms();
                                },
                                child: checkAll ? 
                                Image.asset('assets/images/signup_terms_active.png')
                                :
                                Image.asset('assets/images/signup_terms_inactive.png')
                              ),
                              SizedBox(width: 10,),
                              Text(tr('agreeAll'), textAlign: TextAlign.start, style: TextStyle(color: DivcowColor.textDefault, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 10,),
                          ConstrainedBox(
                            constraints: new BoxConstraints(
                              minHeight: 35.0,
                              maxHeight: 140.0,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: termsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return termsbox(
                                  require: termsList[index]['compulsory'], 
                                  check: termsNo.contains(termsList[index]['seqNo'].toString()), 
                                  title: termsList[index]['title'], 
                                  onCheck: (check) {
                                    checkTerms(check, termsList[index]['seqNo'].toString());
                                  }, 
                                  onPressView: () {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) {
                                          return TermsScreen(url: termsList[index]['url']);
                                        }
                                      )
                                    );
                                  }
                                );
                              }
                            ),
                          ),
                          signupLinearButton(tr('Completed'), 35, [0, 15, 0, 15], signUp),
                        ],
                      ),
                    ) ,
                  ),
                );
              }),
              alertEmail ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  bottomAlertBox(
                    tr('Pleaseenteryouremail'),
                    tr('Confirm'),
                    () {
                      setState(() {
                        alertEmail = false;
                      });
                    }
                  )
                ],
              ) : const SizedBox.shrink(),
              alertNickname ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  bottomAlertBox(
                      tr('Pleaseenteryournickname'),
                      tr('Confirm'),
                    () {
                      setState(() {
                        alertNickname = false;
                      });
                    }
                  )
                ],
              ) : const SizedBox.shrink(),
              alertTerms ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  bottomAlertBox(
                      tr('Pleasetermsandconditions'),
                      tr('Confirm'),
                    () {
                      setState(() {
                        alertTerms = false;
                      });
                    }
                  )
                ],
              ) : const SizedBox.shrink(),
              alertCheckNickname ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  bottomAlertBox(
                      tr('Pleasechecknickname'),
                      tr('Confirm'),
                    () {
                      setState(() {
                        alertCheckNickname = false;
                      });
                    }
                  )
                ],
              ) : const SizedBox.shrink(),

            ],
          )
        )
      )
    );
  }
}