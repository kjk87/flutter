import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_region/device_region.dart';
import 'package:dio/dio.dart';
import 'package:divcow/common/utils/appBar.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/common/utils/loginInfo.dart';
import 'package:divcow/profile/components/checkbox.dart';
import 'package:divcow/profile/components/linear_one_button.dart';
import 'package:divcow/profile/components/management_checkbox.dart';
import 'package:divcow/profile/components/management_countrybox.dart';
import 'package:divcow/profile/components/management_datebox.dart';
import 'package:divcow/profile/components/management_inputbox.dart';
import 'package:divcow/profile/components/management_nicknamebox.dart';
import 'package:divcow/signup/components/bottom_alert_box.dart';
import 'package:divcow/signup/components/linear_button.dart';
import 'package:divcow/signup/components/nicknamebox.dart';
import 'package:divcow/signup/components/termsbox.dart';
import 'package:divcow/signup/screens/terms_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:divcow/signup/components/inputbox.dart';
import 'package:image_picker/image_picker.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});


  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {

  late dynamic user = {};

  late String id = '';
  late String nickname = '';
  late String email = '';
  late String birthday = '';
  late String country = '';
  late String gender = '';
  late String profile = '';
  late XFile image;

  final picker = ImagePicker();

  late dynamic nicknameReject = false;
  
  late bool alertEmail = false;
  late bool alertNickname = false;
  late bool alertCheckNickname = false;

  final TextEditingController idController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customInit();
  }

  @override
  void dispose() {
    
    idController.dispose();
    nicknameController.dispose();
    emailController.dispose();

    super.dispose();
  }

  customInit() async {
    final member = await getUser(context);
    setState(() {
      user = member;
      id = member['userKey'];
      nickname = member['nickname'];
      email = member['email'];
      birthday = member['birthday'] ?? '';
      country = member['nation'] ?? '';
      gender = member['gender'] ?? '';
      profile = member['profile'] ?? '';
    });
  }

  Future<void> updateUser(click) async {

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

    if(nicknameReject == null || nicknameReject == true) {
      setState(() {
        alertCheckNickname = true;
      });
      return;
    }

    var params = {
      'nation': country,
      'nickname': nickname,
      'email': email,
      'birthday': birthday,
      'gender': gender,
      'profile': profile
    };

    var joinResult = await httpPost(path: '/member/update', params: params);
    if(joinResult['code'] == 200) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBarHeader(onPressBack: () {Navigator.of(context).pop(false);}, text: tr('profileManagement')),
        backgroundColor: DivcowColor.background,
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                              if(pickedFile != null) {

                                var formData = FormData.fromMap({'file': await MultipartFile.fromFile(pickedFile.path)});
                                var result = await dioUpload(path: '/file/s3Upload', params: formData);
                                
                                if(result['code'] == 200) {
                                  log(result.toString());
                                  setState(() {
                                    profile = result['result'];
                                  });
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: profile,
                                    width: 90,
                                    height: 90,
                                    placeholder: (context, url) => Image.asset('assets/images/ic_profile_default.png'),
                                    errorWidget: (context, url, error) => Image.asset('assets/images/ic_profile_default.png'),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    )
                                  ),
                                  Image.asset(
                                    'assets/images/profile_image_regist.png',
                                    width: 35,
                                  )
                                ],
                              )
                            ),
                          ),

                          managementInputbox('ID', [0, 10, 0, 0], (text) {}, true, '', idController..text = id),
                          managementNicknamebox(
                            tr('nickname'),
                            [0, 10, 0, 3],
                            tr('availableNickname'),
                            tr('alreadyNickname'),
                            nicknameReject,
                            (text) {
                              setState(() {nickname = text;});
                              setState(() {nicknameReject = null;});
                            },
                            () async {
                              if(user['nickname'] != nickname) {
                                final res = await httpGetWithCode(path: '/member/checkNickname?nickname=$nickname');
                                if(res) {setState(() { nicknameReject = false; });} 
                                else {setState(() { nicknameReject = true; });}
                              } else {
                                setState(() { nicknameReject = false; });
                              }
                            },
                            nicknameController..text = nickname,
                          ),
                          managementInputbox(tr('email'), [0, 10, 0, 0], (text) {setState(() {email = text;});}, false, '', emailController..text = email),
                          managementDatebox(context, tr('birthday'), [0, 10, 0, 0], (text) {setState(() {birthday = text;});}, false, '', birthday),
                          managementCountrybox(context, tr('country'), [0, 10, 0, 0], (text) {setState(() {country = text;});}, false, '', country),

                          managementCheckbox(context, tr('gender'), [0, 10, 0, 0], (text) {setState(() {gender = text;});}, false, '', gender),


                          
                          SizedBox(height: 30,),
                          profileLinearOneButton(tr('completed'), 35, [0, 15, 0, 15], updateUser),
                        ],
                      ),
                  ),
                );
              }),
              alertEmail ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  bottomAlertBox(
                    tr('enterEmail'),
                    tr('confirm'),
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
                    tr('enterNickname'),
                    tr('confirm'),
                    () {
                      setState(() {
                        alertNickname = false;
                      });
                    }
                  )
                ],
              ) : const SizedBox.shrink(),
              alertCheckNickname ? Column(
                children: [
                  Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
                  bottomAlertBox(
                    tr('checkNickname'),
                    tr('confirm'),
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