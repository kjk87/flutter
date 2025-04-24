import 'dart:developer';
import 'package:divcow/profile/components/linear_one_button.dart';
import 'package:divcow/splash/actions/appVersionCheck.dart';
import 'package:divcow/common/utils/appBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

class VersionScreen extends StatefulWidget {
  const VersionScreen({super.key});

  @override
  State<VersionScreen> createState() => _VersionScreenState();
}

class _VersionScreenState extends State<VersionScreen> {

  late String current = '';
  late String lastest = '';
  late bool update = false;

  @override
  void initState() {
    super.initState();
    initialVersion();
  }

  initialVersion() async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var packageVersion = packageInfo.version;
    var app = await getVersion();

    log(packageVersion);
    log(app['version']);

    setState(() {
      current = packageVersion;
      lastest = app['version'];
    });

    if(app['version'] != packageVersion) {
      setState(() {
        update = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: DivcowColor.background,
      appBar: appBarHeader(
        onPressBack: () {Navigator.of(context).pop(false);}, 
        text: tr('versionManagement')
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              SizedBox(height: 40,),
              Image.asset(
                'assets/images/splash_login_logo.png'
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(tr('currentVersion'), style: TextStyle(color: DivcowColor.textDefault, fontSize: 14, fontWeight: FontWeight.bold),),
                  ),
                  Spacer(),
                  Text('ver.$current', style: TextStyle(color: Color.fromRGBO(119, 245, 174, 1), fontSize: 14, fontWeight: FontWeight.bold),),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: DivcowColor.linearMain,
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight
                  )
                ),
                height: 0.8,
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(tr('lastestVersion'), style: TextStyle(color: DivcowColor.textDefault, fontSize: 14, fontWeight: FontWeight.bold),),
                  ),
                  Spacer(),
                  Text('ver.$lastest', style: TextStyle(color: Color.fromRGBO(119, 245, 174, 1), fontSize: 14, fontWeight: FontWeight.bold),),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: DivcowColor.linearMain,
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight
                  )
                ),
                height: 0.8,
              ),
              Spacer(),
              update ?
              profileLinearOneButton(tr('needUpdate'), 40, [0, 0, 0, 20], (click) {})
              :
              profileLinearOneButton(tr('thisLastestVersion'), 40, [0, 0, 0, 20], (click) {})
            ],
          )
        )
      )
    );
  }
}
