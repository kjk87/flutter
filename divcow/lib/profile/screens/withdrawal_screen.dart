import 'package:divcow/common/utils/appBar.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/common/utils/loginInfo.dart';
import 'package:divcow/profile/components/confirm_box.dart';
import 'package:divcow/profile/components/linear_button.dart';
import 'package:divcow/profile/components/linear_one_button.dart';
import 'package:divcow/splash/screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {

  late dynamic userData = {};
  late bool confirm = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    var user = await getUser(context);
    setState(() {
      userData = user;
    });
    
  }

  clickWithdrawal(bool click) async {
    if(click) {
      
      await httpPost(path: '/member/withdrawal');
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashScreen()));


    } else {
      setState(() {
        confirm = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarHeader(onPressBack: () {Navigator.of(context).pop(false);}, text: tr('membershipWithdrawal')),
      backgroundColor: DivcowColor.background,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tr('deletion'), style: TextStyle(fontSize: 14, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: DivcowColor.card
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            // Text('Notice ', style: TextStyle(fontSize: 12, color: DivcowColor.textDefault, fontWeight: FontWeight.bold)),
                                            Text(tr('importantNotice'), style: TextStyle(fontSize: 12, color: DivcowColor.textAccent, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                        SizedBox(height: 3,),
                                        Text(
                                          tr('importantNoticeContents'),
                                          style: TextStyle(fontSize: 11, color: DivcowColor.textDefault),
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: DivcowColor.card
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(tr('inventory'), style: TextStyle(fontSize: 12, color: DivcowColor.textDefault, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 3,),
                                        Row(
                                          children: [
                                            Text(
                                              tr('availablePoint'),
                                              style: TextStyle(fontSize: 11, color: DivcowColor.textDefault),
                                            ),
                                            const Spacer(),
                                            Text(userData['point'] != null ? userData['point'].toString() : '0', style: TextStyle(fontSize: 11, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                            SizedBox(width: 10,),
                                            Image.asset('assets/images/profile_withdrawal_point.png', width: 20,)
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text(
                                              tr('availableTether'),
                                              style: TextStyle(fontSize: 11, color: DivcowColor.textDefault),
                                            ),
                                            const Spacer(),
                                            Text(userData['tether'] != null ? userData['tether'].toString() : '0', style: TextStyle(fontSize: 11, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                            SizedBox(width: 10,),
                                            Image.asset('assets/images/profile_tether.png', width: 20,)
                                          ],
                                        )
                                        
                                      ],
                                    ),
                                  )
                                ),
                                SizedBox(height: 15,),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: DivcowColor.card
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(tr('howToDeletion'), style: TextStyle(fontSize: 12, color: DivcowColor.textDefault, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 3,),
                                        Text(
                                          tr('howToDeletionContents'),
                                          style: TextStyle(fontSize: 11, color: DivcowColor.textDefault),
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                SizedBox(height: 15,),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: DivcowColor.card
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(tr('deletionPeriod'), style: TextStyle(fontSize: 12, color: DivcowColor.textDefault, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 3,),
                                        Text(
                                          tr('deletionPeriodContents'),
                                          style: TextStyle(fontSize: 11, color: DivcowColor.textDefault),
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                Spacer(),
                                profileLinearOneButton(tr('withdrawRequest'), 40, [0, 20, 0, 20], (click) {setState(() { confirm = true; });})
                              ],
                            ),
                          ) 
                        ),
                      ),
                    );
                  }
                )
              )
            ],
          ),
          confirm ? Column(
            children: [
              Flexible(flex: 1, child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4))),
              confirmBox(clickWithdrawal)
            ],
          ) : const SizedBox.shrink(),
        ],
      ) 

    );
  }
}
