import 'package:divcow/common/components/circleIndicator.dart';
import 'package:divcow/common/utils/appBarMove.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/profile/screens/inquire_detail_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InquireScreen extends StatefulWidget {
  const InquireScreen({super.key});

  @override
  State<InquireScreen> createState() => _InquireScreenState();
}

class _InquireScreenState extends State<InquireScreen> {
  late Future<List<dynamic>> inquireList;


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() {
    inquireList = httpListWithCode(path: '/inquire/list');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarHeaderMove(
        onPressBack: () {Navigator.of(context).pop(false);}, 
        text: tr('inquiry'), 
        move: true, 
        moveText: tr('contact'),
        onPressMove: () async { 
          final bool refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) => const InquireDetailScreen()));
          if(refresh) {
            setState(() {
              _fetchData();
            });
          }
        }
      ),
      backgroundColor: DivcowColor.background,
      body: SafeArea(
        child: FutureBuilder(
          future: inquireList,
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list = snapshot.data!;

              return Container(
                width: double.infinity,
                color: DivcowColor.background,
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      if(list.isEmpty) {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: DivcowColor.card,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(tr('noInquiry'), style: TextStyle(fontSize: 15, color: DivcowColor.textDefault),),
                          )
                        );
                      } else {
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
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              list[index]['status'] == 'pending' ? 
                                              tr('waitingResponse')
                                              :
                                              tr('responseCompleted')
                                              , 
                                              style: TextStyle(fontSize: 11, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(list[index]['type'], style: TextStyle(fontSize: 11, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                        Spacer(),
                                        Text(list[index]['regDatetime'], style: TextStyle(fontSize: 11, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Text(list[index]['title'], style: TextStyle(fontSize: 11, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),),
                                    Text(list[index]['contents'], style: TextStyle(fontSize: 10, color: DivcowColor.textDefault),),
                                    SizedBox(height: 10,),
                                    Container(
                                      child: list[index]['status'] == 'complete' && list[index]['reply'] != null ?
                                      Container(
                                        constraints: BoxConstraints(
                                          minHeight: 100,
                                          minWidth: 100
                                        ),
                                        decoration: BoxDecoration(
                                          color: DivcowColor.background,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            list[index]['reply'], 
                                            style: TextStyle(fontSize: 11, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),)
                                        )
                                      )
                                      :
                                      null
                                    )
                                  ],
                                ),
                              )
                            ),
                            SizedBox(height: 20,)
                          ],
                        );
                      }

                    },
                    itemCount: list.isEmpty ? 1 : list.length,
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
