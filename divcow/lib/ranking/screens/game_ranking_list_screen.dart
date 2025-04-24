import 'package:cached_network_image/cached_network_image.dart';
import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/components/item_back.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/common/utils/loginInfo.dart';
import 'package:divcow/data/Games.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GameRankingListScreen extends StatelessWidget {
  final Games games;
  final prizes = [10000000, 5000000, 3000000, 10000];

  GameRankingListScreen(this.games, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DivcowColor.background,
        body: SafeArea(
            child: FutureBuilder(
                future: httpList(path: '/ranking/app?games_id=${games.id}'),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> list = snapshot.data!;
                    if (list.isEmpty) {
                      return Scaffold(
                        appBar: AppBar(
                          centerTitle: false,
                          leadingWidth: 0,
                          titleSpacing: 0,
                          backgroundColor: DivcowColor.background,
                          title: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 20, right: 10, bottom: 10),
                              child: itemBack(context,
                                  tr('GameRanking', args: [games.name]))),
                        ),
                        body: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: DivcowColor.background,
                          ),
                          padding: const EdgeInsets.all(10),
                          child:
                              Text(tr('GameRankingNotPlay', args: [games.name]),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: DivcowColor.textDefault,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                  )),
                        ),
                      );
                    }
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: DivcowColor.background,
                          ),
                          child: CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                centerTitle: false,
                                leadingWidth: 0,
                                titleSpacing: 0,
                                pinned: true,
                                backgroundColor: DivcowColor.background,
                                title: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 20,
                                        right: 10,
                                        bottom: 10),
                                    child: itemBack(context,
                                        tr('GameRanking', args: [games.name]))),
                              ),
                              SliverToBoxAdapter(
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
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(games.image),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(games.name,
                                          style: const TextStyle(
                                            color: DivcowColor.textDefault,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              const SliverPadding(
                                padding: EdgeInsets.all(10),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (c, i) => InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          top: 0,
                                          right: 10,
                                          bottom: 10),
                                      decoration: const BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: DivcowColor.popup,
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 5),
                                          i < 3
                                              ? Image.asset(
                                                  'assets/images/ic_ranking${i + 1}.png',
                                                  width: 34,
                                                  height: 34,
                                                )
                                              : Container(
                                                  width: 34,
                                                  height: 34,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      (i + 1).toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: DivcowColor
                                                            .textDefault,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ))),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: 38,
                                            height: 38,
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://api.divcow.com/api/profile/${list[i]['userKey']}',
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
                                                        decoration:
                                                            BoxDecoration(
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
                                              Text(
                                                  list[i]['memberTotal']
                                                      ['nickname'],
                                                  style: const TextStyle(
                                                    color:
                                                        DivcowColor.textDefault,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  const Text('Record ',
                                                      style: TextStyle(
                                                        color: DivcowColor
                                                            .textDefault,
                                                        fontSize: 11.0,
                                                      )),
                                                  Text(
                                                      list[i]['best_score']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: DivcowColor
                                                            .textDefault,
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  const SizedBox(width: 5),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
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
                                                  width: 28,
                                                  height: 28,
                                                ),
                                                const SizedBox(width: 5),
                                                i < 3
                                                    ? Text(
                                                        numberFormat(prizes[i]),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ))
                                                    : Text(
                                                        numberFormat(prizes[3]),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  childCount: list.length,
                                ),
                              ),
                              const SliverPadding(
                                padding: EdgeInsets.all(50),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                            future: getUser(context),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                dynamic user = snapshot.data!;
                                return FutureBuilder(
                                    future: httpGetWithCode(
                                        path:
                                            '/ranking/myApp?games_id=${games.id.toString()}'),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        dynamic data = snapshot.data!;
                                        return Container(
                                          height: 66,
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(
                                              left: 10,
                                              top: 0,
                                              right: 10,
                                              bottom: 10),
                                          decoration: const BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            color: Color(0xff3F3C91),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(width: 5),
                                              data['ranking'] < 3
                                                  ? Image.asset(
                                                      'assets/images/ic_ranking${data['ranking']}.png',
                                                      width: 34,
                                                      height: 34,
                                                    )
                                                  : data['ranking'] >= 100
                                                      ? Container(
                                                          width: 34,
                                                          height: 34,
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                              '100+',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: DivcowColor
                                                                    .textDefault,
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              )))
                                                      : Container(
                                                          width: 34,
                                                          height: 34,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              data['ranking']
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                color: DivcowColor
                                                                    .textDefault,
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ))),
                                              const SizedBox(width: 5),
                                              user['profile'] != null
                                                  ? SizedBox(
                                                      width: 38,
                                                      height: 38,
                                                      child: CachedNetworkImage(
                                                          imageUrl:
                                                              user['profile'],
                                                          placeholder: (context,
                                                                  url) =>
                                                              Image.asset(
                                                                  'assets/images/ic_profile_default.png'),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                                  'assets/images/ic_profile_default.png'),
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ))),
                                                    )
                                                  : Container(
                                                      width: 38,
                                                      height: 38,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: const AssetImage(
                                                              'assets/images/ic_profile_default.png'),
                                                        ),
                                                      ),
                                                    ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(user['nickname'],
                                                      style: const TextStyle(
                                                        color: DivcowColor
                                                            .textDefault,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      )),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Text(tr('Record'),
                                                          style:
                                                              const TextStyle(
                                                            color: DivcowColor
                                                                .textDefault,
                                                            fontSize: 11.0,
                                                          )),
                                                      Text(
                                                          numberFormat(data[
                                                              'best_score']),
                                                          style:
                                                              const TextStyle(
                                                            color: DivcowColor
                                                                .textDefault,
                                                            fontSize: 11.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                      const SizedBox(width: 5),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    });
                              } else {
                                return const SizedBox();
                              }
                            })
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })));
  }
}
