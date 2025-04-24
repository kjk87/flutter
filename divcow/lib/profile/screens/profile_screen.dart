import 'dart:developer';
import 'package:divcow/coin/screen/divcow_exchange_screen.dart';
import 'package:divcow/coin/screen/tether_exchange_screen.dart';
import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/loginInfo.dart';
import 'package:divcow/profile/components/menu_button.dart';
import 'package:divcow/profile/components/swap_button.dart';
import 'package:divcow/profile/screens/inquire_screen.dart';
import 'package:divcow/profile/screens/faq_screen.dart';
import 'package:divcow/profile/screens/management_screen.dart';
import 'package:divcow/profile/screens/notice_screen.dart';
import 'package:divcow/profile/screens/notification_screen.dart';
import 'package:divcow/profile/screens/setting_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({super.key});

  @override
  State<ProfileMainScreen> createState() => _ProfileMainScreen();
}

class _ProfileMainScreen extends State<ProfileMainScreen> {
  
  late dynamic user = {};

  @override
  void initState() {
    super.initState();
    customInit();
  }

  customInit() async {
    final member = await getUser(context);
    log('$member');
    setState(() {
      user = member;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DivcowColor.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                  },
                  child: Image.asset('assets/images/profile_notification.png', width: 20, height: 20,),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: DivcowColor.popup,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10)
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagementScreen()));
                              if(!result) {
                                customInit();
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 90,
                                  child: user['profile'] == null ?
                                  Image.asset('assets/images/ic_profile_default.png')
                                  :
                                  CachedNetworkImage(
                                    imageUrl: user['profile'].toString(),
                                    width: 90,
                                    height: 90,
                                    placeholder: (context, url) => Image.asset('assets/images/ic_profile_default.png'),
                                    errorWidget: (context, url, error) => Image.asset('assets/images/ic_profile_default.png'),
                                    imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                    )
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  alignment: Alignment.topCenter,
                                  child: Text(user['nickname'] ?? '', style: TextStyle(color: DivcowColor.textDefault, fontSize: 17, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ) 
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: DivcowColor.card,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10)
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 16,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/images/profile_coin.png', width: 27),
                                          Container(
                                            height: 21,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10)
                                              ),
                                              gradient: LinearGradient(
                                                colors: [Color.fromRGBO(255, 166, 0, 1), Color.fromRGBO(255, 192, 0, 1),]
                                              )
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: Text(numberFormat(user['point'] ?? 0), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                            ) 
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 9,),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(tr('pointsHeld'), style: TextStyle(fontSize: 15, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                      ),
                                      Row(
                                        children: [
                                          swapButton('assets/images/ic_divcow_coin_s.png', 22, 'DIVCHAIN', 14, () async {
                                            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const DivCowExchangeScreen()));
                                            if(!result) {
                                              customInit();
                                            }
                                          }),
                                          swapButton('assets/images/profile_tether.png', 16, 'TETHER', 14, () async {
                                            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const TetherExchangeScreen()));
                                            if(!result) {
                                              customInit();
                                            }
                                          })
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                                menuButton('assets/images/profile_faq.png', 23, 'FAQ`S', 14, [0, 20, 0, 10], () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqScreen()));
                                }),
                                menuButton('assets/images/profile_inquiry.png', 23, tr('inquiry'), 14, [0, 10, 0, 10], () async {
                                  await reloadSession(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const InquireScreen()));
                                }),
                                menuButton('assets/images/profile_notice.png', 23, tr('notice'), 14, [0, 10, 0, 10], () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticeScreen()));
                                }),
                                menuButton('assets/images/profile_setting.png', 23, tr('setting'), 14, [0, 10, 0, 0], () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
                                }),

                              ],
                            )
                          )
                        ],
                      )
                    ],
                  ),
                )
              ),
            ],
          ),
        )
      ),
    );
  }
}
