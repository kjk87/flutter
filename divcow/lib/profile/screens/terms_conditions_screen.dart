import 'package:divcow/common/components/circleIndicator.dart';
import 'package:divcow/common/utils/appBar.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/signup/screens/terms_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileTermsScreen extends StatefulWidget {

  const ProfileTermsScreen({super.key});

  @override
  State<ProfileTermsScreen> createState() => _ProfileTermsScreenState();
}

class _ProfileTermsScreenState extends State<ProfileTermsScreen> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarHeader(onPressBack: () {Navigator.of(context).pop(false);}, text: tr('termsConditions')),
      backgroundColor: DivcowColor.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            FutureBuilder(
              future: httpListWithCode(path: '/terms'), 
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> list = snapshot.data!;

                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) {
                                    return TermsScreen(url: list[index]['url']);
                                  }
                                )
                              );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
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
                                Text(list[index]['title'], style: const TextStyle(color: DivcowColor.textDefault, fontSize: 12, fontWeight: FontWeight.bold),),
                                const Spacer(),
                                Image.asset('assets/images/setting_arrow.png', width: 20,)
                              ],
                            ) 
                          ),
                        );
                      },
                      itemCount: list.length,
                    )
                  );
                } else {
                  return circleIndicator();
                }
              }
            ),
          ],
        ) 
      )

    );
  }
}

