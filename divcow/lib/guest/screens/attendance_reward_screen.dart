import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/components/item_back.dart';
import 'package:divcow/common/components/toast.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AttendanceRewardScreen extends StatefulWidget {
  const AttendanceRewardScreen({super.key});

  @override
  State<AttendanceRewardScreen> createState() => _AttendanceRewardScreenState();
}

class _AttendanceRewardScreenState extends State<AttendanceRewardScreen> {
  late Future<List<dynamic>> dailyList;
  bool showProgress = false;
  bool isAvailable = false;


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() {
    dailyList = httpList(path: '/clicker/app-daily-tasks');
  }

    @override
  Widget build(BuildContext context) {
    bool showProgress = false;

    return Scaffold(
        backgroundColor: DivcowColor.background,
        body: SafeArea(
            child: FutureBuilder(
                future: dailyList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> list = snapshot.data!;
                    for(dynamic item in list){
                      if(item['available'] == 1&& !(item['completed'] == 1)){
                        isAvailable = true;
                        break;
                      };
                    }
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 10, top: 0, right: 10, bottom: 15),
                      decoration: const BoxDecoration(
                        color: DivcowColor.background,
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                centerTitle: false,
                                leadingWidth: 0,
                                titleSpacing: 0,
                                pinned: true,
                                backgroundColor: DivcowColor.background,
                                title: Container(
                                    padding: const EdgeInsets.only(
                                        left: 0, top: 20, right: 0, bottom: 10),
                                    child: itemBack(context, tr('AttendanceReward'))
                                ),
                              ),
                              DecoratedSliver(
                                decoration: const BoxDecoration(
                                  color: DivcowColor.popup,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                sliver: SliverPadding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 20, right: 15, bottom: 20),
                                  sliver: SliverMainAxisGroup(
                                    slivers: [
                                      SliverToBoxAdapter(
                                          child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(tr('CumulativeAttendanceDays'),
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                color: DivcowColor.textDefault,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                              )),
                                          const Spacer(),
                                        ],
                                      )),
                                      const SliverPadding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      SliverToBoxAdapter(
                                          child: Container(
                                        height: 1,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                      )),
                                      const SliverPadding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      SliverGrid(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          childAspectRatio: 0.8,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                          (c, i) => Container(
                                            decoration: BoxDecoration(
                                                color: list[i]['completed'] ==
                                                        1
                                                    ? const Color(0xff519A51)
                                                    : const Color(0xff3A56B2),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(list[i]['name'],
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: DivcowColor.textDefault,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                const SizedBox(height: 5),
                                                Image.asset(
                                                  'assets/images/ic_attendance_coin.png',
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.fill,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(numberFormat(list[i]['reward_coins']),
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: DivcowColor.textDefault,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          childCount: list.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SliverPadding(
                                padding: EdgeInsets.all(5),
                              ),
                              SliverToBoxAdapter(
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/ic_exclamation_mark.png',
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(tr('AttendanceRewardDesc'),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  color: DivcowColor.textDefault,
                                                  fontSize: 12.0,
                                                  // fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                        ],
                                      ))),
                              const SliverPadding(
                                padding: EdgeInsets.all(50),
                              ),
                            ],
                          ),
                          showProgress
                              ? Container(
                                  height: 44,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [0.0, 1.0],
                                      colors: DivcowColor.linearMain,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                  ),
                                  child: const CircularProgressIndicator(),
                                )
                              : InkWell(
                                  onTap: () async {
                                    if(isAvailable){
                                      setState(() {
                                        showProgress = true;
                                      });
                                      await httpPost(path: '/clicker/app-claim-daily-task');
                                      toast(tr('AttendanceCompleted'));
                                      setState(() {
                                        showProgress = false;
                                        isAvailable = false;
                                        _fetchData();
                                      });
                                    }else{
                                      toast(tr('AttendanceToast1'));
                                    }
                                  },
                                  child: Container(
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [0.0, 1.0],
                                        colors: DivcowColor.linearMain,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(22)),
                                    ),
                                    child: Text(tr('AttendanceCheck'),
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: DivcowColor.textDefault,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                        )),
                                  ),
                                )
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                })));
  }
}
