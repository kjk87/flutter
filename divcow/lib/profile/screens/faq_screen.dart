import 'package:divcow/common/components/circleIndicator.dart';
import 'package:divcow/common/utils/appBar.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late Future<List<dynamic>> faqList;
  late Future<List<dynamic>> faqCategoryList;
  late dynamic category = null;

  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }

  _fetchFaq() {
    faqList = httpListWithCode(path: '/faq/list?category=$category');
  }

  _fetchCategory() {
    faqCategoryList = httpListWithCode(path: '/faq/category/list');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarHeader(onPressBack: () {Navigator.of(context).pop(false);}, text: 'FAQ`S'),
      backgroundColor: DivcowColor.background,
      body: SafeArea(
        child: FutureBuilder(
          future: faqCategoryList,
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list = snapshot.data!;
              
              if(category == null && list[0] != null) {
                category = list[0]['seqNo'];
                _fetchFaq();
              }

              return Container(
                width: double.infinity,
                color: DivcowColor.background,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        color: DivcowColor.background,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      category = list[index]['seqNo'];
                                      _fetchFaq();
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 38,
                                    color: DivcowColor.background,
                                    alignment: Alignment.center,
                                    child: Text(list[index]['name'], style: TextStyle(color: DivcowColor.textDefault, fontSize: 14, fontWeight: FontWeight.bold),),
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: 
                                        category == list[index]['seqNo'] ? 
                                        [Color.fromRGBO(106, 17, 203, 1), Color.fromRGBO(37, 117, 252, 1)] 
                                        : 
                                        [Color.fromRGBO(190, 96, 242, 0.21), Color.fromRGBO(190, 96, 242, 0.21)],
                                    )
                                  ),
                                )
                              ],
                            );
                          },
                          itemCount: list.length,
                        )
                      ),
                      SizedBox(height: 15,),
                      FutureBuilder(
                        future: faqList,
                        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> list = snapshot.data!;

                            return Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        color: DivcowColor.background,
                                        alignment: Alignment.center,
                                        child: ListTileTheme(
                                          contentPadding: EdgeInsets.all(0),
                                          dense: true,
                                          horizontalTitleGap: 0.0,
                                          minLeadingWidth: 0,
                                          child: ExpansionTile(
                                            title: Text(list[index]['title'], style: TextStyle(fontSize: 16, color: DivcowColor.textDefault),),
                                            children: [
                                              Text(list[index]['contents'], style: TextStyle(fontSize: 15, color: DivcowColor.textDefault),),
                                            ],
                                            shape: const Border(),
                                            iconColor: DivcowColor.textDefault,
                                            collapsedIconColor: DivcowColor.textDefault,
                                            minTileHeight: 50,
                                          )
                                        )
                                      ),
                                    ],
                                  );
                                },
                                itemCount: list.length,
                              )
                            );

                          } else {
                            return Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                      )
                    ],
                  ),
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
