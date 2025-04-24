import 'package:cached_network_image/cached_network_image.dart';
import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/data/Games.dart';
import 'package:divcow/games/components/image_slider.dart';
import 'package:divcow/ranking/screens/game_ranking_list_screen.dart';
import 'package:divcow/ranking/screens/prize_ranking_list_screen.dart';
import 'package:divcow/ranking/screens/tether_ranking_list_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RankingListScreen extends StatelessWidget {
  const RankingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DivcowColor.background,
        body: SafeArea(
            child: FutureBuilder(
                future: httpList(path: '/games/listWithMyAppRanking'),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> list = snapshot.data!;
                    return Container(
                      decoration: const BoxDecoration(
                        color: DivcowColor.background,
                      ),
                      child: CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, right: 10, bottom: 10),
                            sliver: SliverToBoxAdapter(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TetherRankingListScreen()));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: DivcowColor.card,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(23),
                                          bottomLeft: Radius.circular(23),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/ic_game_tether.png',
                                          width: 34,
                                          height: 34,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(tr('TetherRanking'),
                                            style: const TextStyle(
                                              color: DivcowColor.textDefault,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700,
                                            )),
                                        const SizedBox(width: 5),
                                        Image.asset(
                                          'assets/images/ic_arrow_w.png',
                                          width: 18,
                                          height: 18,
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PrizeRankingListScreen()));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: DivcowColor.card,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(23),
                                          bottomLeft: Radius.circular(23),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/ic_game_coin.png',
                                          width: 34,
                                          height: 34,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(tr('PrizeRanking'),
                                            style: const TextStyle(
                                              color: DivcowColor.textDefault,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700,
                                            )),
                                        const SizedBox(width: 5),
                                        Image.asset(
                                          'assets/images/ic_arrow_w.png',
                                          width: 18,
                                          height: 18,
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                          ),
                          SliverToBoxAdapter(
                              child: FutureBuilder(
                                  future: httpListWithCode(
                                      path: '/banner?type=ranking'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.isNotEmpty) {
                                      List<dynamic> list = snapshot.data!;
                                      return imageSlider(list);
                                    } else {
                                      return const SizedBox();
                                    }
                                  })),
                          const SliverPadding(
                            padding: EdgeInsets.all(10),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (c, i) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GameRankingListScreen(
                                                  Games.fromMap(list[i]))));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(
                                      left: 10, top: 0, right: 10, bottom: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: DivcowColor.popup,
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        width: 38,
                                        height: 38,
                                        child: CachedNetworkImage(
                                            imageUrl: list[i]['image'],
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
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ))),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(list[i]['name'],
                                              style: const TextStyle(
                                                color: DivcowColor.textDefault,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                              )),
                                          const SizedBox(height: 2),
                                          Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                stops: [0.0, 1.0],
                                                colors: [
                                                  Color(0xffFFA600),
                                                  Color(0xffFFC000)
                                                ],
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(23)),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/ic_my_ranking_coin.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                    numberFormat(
                                                        list[i]['prize_1']),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                const SizedBox(width: 5),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          list[i]['ranking'] == null
                                              ? Text(tr('NoRank'),
                                                  style: const TextStyle(
                                                    color:
                                                        DivcowColor.textDefault,
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w700,
                                                  ))
                                              : list[i]['ranking']['ranking'] <=
                                                      3
                                                  ? Image.asset(
                                                      'assets/images/ic_my_ranking${list[i]['ranking']['ranking']}.png',
                                                      width: 18,
                                                      height: 18,
                                                    )
                                                  : SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child: Text(
                                                          list[i]['ranking']
                                                                  ['ranking']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: DivcowColor
                                                                .textDefault,
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                          const SizedBox(height: 5),
                                          Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                                color: Color(0xff000000),
                                              ),
                                              child: Text(tr('MyRank'),
                                                  style: const TextStyle(
                                                    color:
                                                        DivcowColor.textDefault,
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w700,
                                                  ))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              childCount: list.length,
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
