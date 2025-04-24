import 'package:cached_network_image/cached_network_image.dart';
import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/common/utils/loginInfo.dart';
import 'package:divcow/data/Games.dart';
import 'package:divcow/games/components/image_slider.dart';
import 'package:divcow/games/screens/game_webview_screen.dart';
import 'package:divcow/history/screen/history_point_screen.dart';
import 'package:divcow/history/screen/history_tether_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GameListScreen extends StatelessWidget {
  const GameListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DivcowColor.background,
        body: SafeArea(
            child: FutureBuilder(
                future: httpList(path: '/games'),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<Games> list = snapshot.data!
                        .map((dynamic item) => Games.fromMap(item))
                        .toList();
                    List<Games> rankingList =
                        list.where((o) => o.is_ranking == true).toList();
                    List<Games> noRankingList =
                        list.where((o) => o.is_ranking == false).toList();
                    return Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/bg.png'),
                            fit: BoxFit.cover),
                      ),
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, right: 10, bottom: 10),
                            sliver: SliverToBoxAdapter(
                                child: FutureBuilder(
                                    future: getUser(context),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        dynamic user = snapshot.data!;
                                        return Row(children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HistoryTetherScreen()));
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xff3E407C),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(23)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/ic_game_tether.png',
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      numberFormat(user['tether']),
                                                      style: const TextStyle(
                                                        color: DivcowColor
                                                            .textDefault,
                                                        fontSize: 10.0,
                                                      )),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HistoryPointScreen()));
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xff3E407C),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(23)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/ic_game_coin.png',
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      numberFormat(
                                                          user['point']),
                                                      style: const TextStyle(
                                                        color: DivcowColor
                                                            .textDefault,
                                                        fontSize: 10.0,
                                                      )),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                        ]);
                                      } else {
                                        return const SizedBox();
                                      }
                                    })),
                          ),
                          SliverToBoxAdapter(
                              child: FutureBuilder(
                                  future: httpListWithCode(
                                      path: '/banner?type=game'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.hasData) {
                                      List<dynamic> list = snapshot.data!;
                                      return imageSlider(list);
                                    } else {
                                      return const SizedBox();
                                    }
                                  })),
                          SliverPadding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, right: 10, bottom: 10),
                            sliver: DecoratedSliver(
                              decoration: const BoxDecoration(
                                color: Color(0xff272564),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              sliver: SliverPadding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 15, right: 10, bottom: 15),
                                sliver: SliverMainAxisGroup(
                                  slivers: [
                                    SliverPadding(
                                      padding: const EdgeInsets.only(
                                          left: 0,
                                          top: 0,
                                          right: 0,
                                          bottom: 15),
                                      sliver: SliverToBoxAdapter(
                                          child: Container(
                                        alignment: Alignment.center,
                                        child: Text(tr('rankingGameTitle'),
                                            style: const TextStyle(
                                              color: DivcowColor.textDefault,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w700,
                                            )),
                                      )),
                                    ),
                                    SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8),
                                      delegate: SliverChildBuilderDelegate(
                                        (c, i) => InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GameWebviewScreen(
                                                            rankingList[i])));
                                          },
                                          child: CachedNetworkImage(
                                              imageUrl: rankingList[i].image,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      'assets/images/ic_profile_default.png'),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'assets/images/ic_profile_default.png'),
                                              imageBuilder: (context,
                                                      imageProvider) =>
                                                  Container(
                                                      decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ))),
                                        ),
                                        childCount: rankingList.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(10),
                            sliver: DecoratedSliver(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              sliver: SliverPadding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 20, right: 10, bottom: 15),
                                sliver: SliverMainAxisGroup(
                                  slivers: [
                                    SliverPadding(
                                      padding: const EdgeInsets.only(
                                          left: 0,
                                          top: 0,
                                          right: 0,
                                          bottom: 15),
                                      sliver: SliverToBoxAdapter(
                                          child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(tr('noRankingGameTitle'),
                                                style: TextStyle(
                                                  color:
                                                      DivcowColor.textDefault,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(tr('noRankingGameDesc'),
                                                style: const TextStyle(
                                                  color:
                                                      DivcowColor.textDefault,
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          )
                                        ],
                                      )),
                                    ),
                                    SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8),
                                      delegate: SliverChildBuilderDelegate(
                                        (c, i) => InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GameWebviewScreen(
                                                            noRankingList[i])));
                                          },
                                          child: CachedNetworkImage(
                                              imageUrl: noRankingList[i].image,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      'assets/images/ic_profile_default.png'),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'assets/images/ic_profile_default.png'),
                                              imageBuilder: (context,
                                                      imageProvider) =>
                                                  Container(
                                                      decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ))),
                                        ),
                                        childCount: noRankingList.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })));
  }
}
