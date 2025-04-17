import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:device_region/device_region.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/core/localization/app_localization.dart';
import 'package:divigo/screens/signin/terms_screen.dart';
import 'package:divigo/widgets/signin/bottom_alert_box.dart';
import 'package:divigo/widgets/signin/inputbox.dart';
import 'package:divigo/widgets/signin/linear_button.dart';
import 'package:divigo/widgets/signin/nicknamebox.dart';
import 'package:divigo/widgets/signin/signInApp.dart';
import 'package:divigo/widgets/signin/termsbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  final String joinType;
  final String joinPlatform;
  final String platformKey;
  final String? platformEmail;
  final String deviceId;

  const SignupScreen(
      {super.key,
      required this.joinType,
      required this.joinPlatform,
      required this.platformKey,
      required this.platformEmail,
      required this.deviceId});

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

  late bool alertNickname = false;
  late bool alertTerms = false;
  late bool alertCheckNickname = false;

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController referrerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initReferrerDetails();
    getTerms();
  }

  @override
  void dispose() {
    nicknameController.dispose();
    referrerController.dispose();

    super.dispose();
  }

  Future<void> initReferrerDetails() async {
    String referrerDetailsString;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;

      referrerDetailsString = referrerDetails.installReferrer.toString();
    } catch (e) {
      referrerDetailsString = 'Failed to get referrer details: $e';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      // referralCode = referrerDetailsString;
    });
  }

  Future<void> getTerms() async {
    var res = await httpListWithCode(path: '/terms');
    setState(() {
      termsList = res;
    });
  }

  checkTerms(bool check, String seqNo) {
    if (check) {
      setState(() {
        termsNo.add(seqNo);
      });
    } else {
      setState(() {
        termsNo.removeWhere((item) => item == seqNo);
      });
    }

    if (termsList.length > 0 && termsList.length == termsNo.length) {
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
    if (termsList.length > 0 && termsList.length == termsNo.length) {
      setState(() {
        checkAll = false;
        termsNo = [];
      });
    } else {
      List<String> nos = [];
      for (dynamic terms in termsList) {
        nos.add(terms['seqNo'].toString());
      }
      setState(() {
        checkAll = true;
        termsNo = nos;
      });
    }
  }

  Future<void> signUp() async {
    if (nickname == '') {
      setState(() {
        alertNickname = true;
      });
      return;
    }

    if (termsList.length > 0) {
      for (var term in termsList) {
        if (term['compulsory'] == true) {
          if (!termsNo.contains(term['seqNo'].toString())) {
            setState(() {
              alertTerms = true;
            });
            return;
          }
        }
      }
    }

    if (nicknameReject == null || nicknameReject == true) {
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
      'email': widget.platformEmail,
      'platformKey': widget.platformKey,
      'language': languageCode,
      'platformEmail': widget.platformEmail,
      'device': widget.deviceId
    };

    var joinResult = await httpPost(path: '/member/join2', params: params);
    if (joinResult['code'] == 200) {
      await checkJoinPlatform(context, widget.platformKey, email,
          widget.deviceId, widget.joinPlatform, widget.joinType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Stack(
              children: [
                LayoutBuilder(builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 20,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalization.of(context)
                                          .get('welcomeTo'),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      AppLocalization.of(context)
                                          .get('registration'),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey[100]!,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  signupNicknamebox(
                                      AppLocalization.of(context)
                                          .get('nickname'),
                                      [0, 0, 0, 16],
                                      AppLocalization.of(context)
                                          .get('nicknameAvailable'),
                                      AppLocalization.of(context)
                                          .get('nicknameUsed'),
                                      nicknameReject, (text) {
                                    setState(() {
                                      nickname = text;
                                      nicknameReject = null;
                                    });
                                  }, () async {
                                    final res = await httpGetWithCode(
                                        path:
                                            '/member/checkNickname?nickname=$nickname');
                                    setState(() {
                                      nicknameReject = !res;
                                    });
                                  }, nicknameController),
                                  signupInputbox(
                                      AppLocalization.of(context)
                                          .get('referralCode'),
                                      [0, 0, 0, 0], (text) {
                                    setState(() {
                                      referralCode = text;
                                    });
                                  }, null,
                                      referrerController..text = referralCode),
                                ],
                              ),
                            ),
                            SizedBox(height: 32),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey[100]!,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      checkAllTerms();
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: checkAll
                                                ? Colors.blue
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: checkAll
                                                  ? Colors.blue
                                                  : Colors.grey[300]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: checkAll
                                              ? Icon(Icons.check,
                                                  size: 18, color: Colors.white)
                                              : null,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          AppLocalization.of(context)
                                              .get('agreeToAllTerms'),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    constraints: BoxConstraints(
                                      minHeight: 35.0,
                                      maxHeight: 140.0,
                                    ),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: termsList.length,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 12),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return termsbox(
                                          require: termsList[index]
                                              ['compulsory'],
                                          check: termsNo.contains(
                                              termsList[index]['seqNo']
                                                  .toString()),
                                          title: termsList[index]['title'],
                                          onCheck: (check) {
                                            checkTerms(
                                                check,
                                                termsList[index]['seqNo']
                                                    .toString());
                                          },
                                          onPressView: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) {
                                                      return TermsScreen(
                                                          url: termsList[index]
                                                              ['url']);
                                                    }));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32),
                            Container(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: signUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  AppLocalization.of(context)
                                      .get('completeRegistration'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                if (alertNickname || alertTerms || alertCheckNickname)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 32),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              alertNickname
                                  ? AppLocalization.of(context)
                                      .get('pleaseEnterYourNickname')
                                  : alertTerms
                                      ? AppLocalization.of(context).get(
                                          'pleaseAgreeToTermsAndConditions')
                                      : AppLocalization.of(context).get(
                                          'pleaseCheckNicknameAvailability'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    alertNickname = false;
                                    alertTerms = false;
                                    alertCheckNickname = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  AppLocalization.of(context).get('confirm'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ))));
  }
}
