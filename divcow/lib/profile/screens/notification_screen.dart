import 'dart:developer';

import 'package:divcow/common/components/circleIndicator.dart';
import 'package:divcow/common/utils/appBar.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<dynamic>> notificationList;


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() {
    notificationList = httpListWithCode(path: '/notificationBox/list');
  }

  _deleteNotification(int seqNo) async {
    await httpPost(path: '/notificationBox/delete', params: {'seqNo': seqNo});
    _fetchData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarHeader(
        onPressBack: () {Navigator.of(context).pop(false);}, 
        text: tr('notification')
      ),
      backgroundColor: DivcowColor.background,
      body: SafeArea(
        child: FutureBuilder(
          future: notificationList,
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list = snapshot.data!;
              if (list.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: DivcowColor.background,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(tr('notificationNotExist'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: DivcowColor.textDefault,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      )),
                );
              }
              return Container(
                width: double.infinity,
                color: DivcowColor.background,
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: DivcowColor.card,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: DivcowColor.linearMain
                                          ),
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(9),
                                          child: Text(
                                            tr('notification'), 
                                            style: TextStyle(fontSize: 13, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(list[index]['regDatetime'], style: TextStyle(fontSize: 13, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                      SizedBox(width: 20,),
                                      GestureDetector(
                                        onTap: () {
                                          _deleteNotification(list[index]['seqNo']);
                                        },
                                        child: Image.asset(
                                          'assets/images/ic_disconnect.png',
                                          width: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Text(list[index]['title'], style: TextStyle(fontSize: 12, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                  Html(
                                    data: list[index]['contents'],
                                    style: {
                                      'body': Style(
                                        color: DivcowColor.textDefault
                                      )
                                    },
                                    // style: {"p": Style(color: DivcowColor.textDefault)},
                                  ),
                                ],
                              ),
                            )
                          ),
                          SizedBox(height: 20,)
                        ],
                      );
                    },
                    itemCount: list.length,
                  )
                )
              );
            } else {
              return circleIndicator();
            }
          }
        )
      )
    );
  }
}
