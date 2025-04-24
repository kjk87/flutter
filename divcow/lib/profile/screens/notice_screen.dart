import 'package:divcow/common/components/circleIndicator.dart';
import 'package:divcow/common/utils/appBar.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  late Future<List<dynamic>> noticeList;


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() {
    noticeList = httpListWithCode(path: '/notice/list');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarHeader(
        onPressBack: () {Navigator.of(context).pop(false);}, 
        text: tr('notice')
      ),
      backgroundColor: DivcowColor.background,
      body: SafeArea(
        child: FutureBuilder(
          future: noticeList,
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list = snapshot.data!;

              return Container(
                width: double.infinity,
                color: DivcowColor.background,
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
                                          child: Text('Divcow Notice', style: TextStyle(fontSize: 13, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(list[index]['regDatetime'], style: TextStyle(fontSize: 13, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
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
