import 'package:divcow/common/utils/appBar.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/loginInfo.dart';
import 'package:divcow/profile/components/linear_one_button.dart';
import 'package:divcow/profile/screens/notifications_screen.dart';
import 'package:divcow/profile/screens/terms_conditions_screen.dart';
import 'package:divcow/profile/screens/version_screen.dart';
import 'package:divcow/profile/screens/withdrawal_screen.dart';
import 'package:divcow/splash/screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  late String version = '';
  late dynamic userData = {};

  @override
  void initState() {
    super.initState();
    initialize();
  }



  initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var user = await getUser(context);
    setState(() {
      version = packageInfo.version;  
      userData = user;
    });
    
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarHeader(onPressBack: () {Navigator.of(context).pop(false);}, text: tr('setting')),
      backgroundColor: DivcowColor.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: DivcowColor.background,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    color: DivcowColor.background,
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(56, 37, 110, 1),
                        width: 1
                      )
                    )
                  ),
                  child: ListTileTheme(
                    contentPadding: const EdgeInsets.all(0),
                    dense: true,
                    horizontalTitleGap: 0.0,
                    minLeadingWidth: 0,
                    child: ExpansionTile(
                      title: Text(tr('accountInfomation'), style: TextStyle(fontSize: 16, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                      shape: const Border(),
                      iconColor: Color.fromRGBO(255, 255, 255, 1),
                      collapsedIconColor: Color.fromRGBO(255, 255, 255, 1),
                      minTileHeight: 50,
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(29, 26, 120, 1),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              children: [
                                Text(userData['email'] ?? '', style: const TextStyle(fontSize: 15, color: DivcowColor.textDefault),),
                                const SizedBox(width: 10,),
                                userData['joinType'] == 'google' ? 
                                Image.asset('assets/images/splash_login_google.png', width: 24,)
                                :
                                userData['joinType'] == 'apple' ? 
                                Image.asset('assets/images/splash_login_apple.png', width: 24,)
                                :
                                const SizedBox()
                              ],
                            )
                          ) 
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(29, 26, 120, 1),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ID', style: TextStyle(fontSize: 16, color: DivcowColor.textDefault)),
                                Row(
                                  children: [
                                    Text(userData['userKey'] ?? '', style: const TextStyle(fontSize: 15, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const WithdrawalScreen()));
                                      },
                                      child: Text(tr('membershipWithdrawal'), style: TextStyle(fontSize: 16, color: DivcowColor.textAccent, fontWeight: FontWeight.bold),),
                                    )
                                  ],
                                )
                              ],
                            )
                          ) 
                        ),
                      ],
                    )
                  )
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileTermsScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: DivcowColor.background,
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(56, 37, 110, 1),
                          width: 1
                        )
                      )
                    ),
                    child: Row(
                      children: [
                        Text(tr('termsConditions'), style: TextStyle(color: DivcowColor.textDefault, fontSize: 16, fontWeight: FontWeight.bold),),
                        const Spacer(),
                        Image.asset('assets/images/setting_arrow.png', width: 20,)
                      ],
                    ) 
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const VersionScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: DivcowColor.background,
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(56, 37, 110, 1),
                          width: 1
                        )
                      )
                    ),
                    child: Row(
                      children: [
                        Text(tr('versionManagement'), style: TextStyle(color: DivcowColor.textDefault, fontSize: 16, fontWeight: FontWeight.bold),),
                        const Spacer(),
                        Text('ver.$version', style: const TextStyle(fontSize: 17, color: Color.fromRGBO(76, 217, 100, 1), fontWeight: FontWeight.bold),),
                        const SizedBox(width: 5,),
                        Image.asset('assets/images/setting_arrow.png', width: 20,)
                      ],
                    ) 
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: DivcowColor.background,
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(56, 37, 110, 1),
                          width: 1
                        )
                      )
                    ),
                    child: Row(
                      children: [
                        Text(tr('notificationSettings'), style: TextStyle(color: DivcowColor.textDefault, fontSize: 16, fontWeight: FontWeight.bold),),
                        const Spacer(),
                        Image.asset('assets/images/setting_arrow.png', width: 20,)
                      ],
                    ) 
                  ),
                ),
                const Spacer(),
                profileLinearOneButton(tr('logout'), 40, [0, 0, 0, 20], (click) async {
                  const storage = FlutterSecureStorage();
                  await storage.deleteAll();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
                })
              ],
            )
          ) 
        )
      )
    );
  }
}
