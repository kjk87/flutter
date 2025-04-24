import 'package:divcow/common/utils/appBar.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/deviceInfo.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  late bool switchValue = false;
  late String id = '';

  @override
  void initState() {
    super.initState();
    getPushActivate();
  }

  getPushActivate() async {

    var info = await deviceInfo();
    id = info['id'];

    var res = await httpGetWithCode(path: '/device?deviceId=$id');

    setState(() {
      switchValue = res['pushActivate'];
    });

    
  }

  changeSwitch(bool value) {
    
    httpPost(path: '/device/push', params: {'deviceId': id, 'pushActivate': value});
    setState(() {
      switchValue = value;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: DivcowColor.background,
      appBar: appBarHeader(
        onPressBack: () {Navigator.of(context).pop(false);}, 
        text: tr('notificationSettings')
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DivcowColor.card
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(tr('serviceNotifications'), style: TextStyle(fontSize: 12, color: DivcowColor.textDefault, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              value: switchValue,
                              onChanged: (bool value) {
                                changeSwitch(value);
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 3,),
                      Text(
                        tr('receivingAlert'),
                        style: TextStyle(fontSize: 11, color: DivcowColor.textDefault),
                      )
                    ],
                  ),
                )
              ),
              Spacer()
            ],
          ) 
        )
      )
    );
  }
}
