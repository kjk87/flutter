import 'package:cached_network_image/cached_network_image.dart';
import 'package:divigo/common/components/format.dart';
import 'package:divigo/common/components/item_back.dart';
import 'package:divigo/common/utils/colors.dart';
import 'package:divigo/common/utils/loginInfo.dart';
import 'package:divigo/models/member.dart';
import 'package:flutter/material.dart';

import '../../common/utils/http.dart';
import '../../core/localization/app_localization.dart';
import '../../models/game_info.dart';

class GameRankingListScreen extends StatelessWidget {
  final Games games;
  final prizes = [10000, 5000, 3000, 500];

  GameRankingListScreen(this.games, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                          backgroundColor: DivigoColor.background,
                          title: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 20, right: 10, bottom: 10),
                              child: itemBack(
                                  context,
                                  AppLocalization.of(context)
                                      .get('GameRanking')
                                      .replaceAll('%s', games.name))),
                        ),
                        body: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              AppLocalization.of(context)
                                  .get('GameRankingNotPlay')
                                  .replaceAll('%s', games.name),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
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
                            color: Colors.white,
                          ),
                          child: CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                centerTitle: false,
                                backgroundColor: Colors.white,
                                elevation: 0,
                                iconTheme: const IconThemeData(
                                    color: Color(0xFF6C72CB)),
                                title: Text(
                                  AppLocalization.of(context)
                                      .get('GameRanking')
                                      .replaceAll('%s', games.name),
                                  style: const TextStyle(
                                    color: Color(0xFF6C72CB),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                leading: IconButton(
                                  icon: Icon(Icons.arrow_back_ios, size: 24),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: DivigoColor.textAccent,
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
                                            color: DivigoColor.textDefault,
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
                                      padding: const EdgeInsets.all(16),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.1),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.08),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          _buildRankingBadge(i),
                                          const SizedBox(width: 12),
                                          _buildProfileImage(
                                              list[i]['userKey']),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  list[i]['memberTotal']
                                                      ['nickname'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Record\n${list[i]['best_score']}',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF6C72CB)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/ic_my_ranking_coin.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  numberFormat(i < 3
                                                      ? prizes[i]
                                                      : prizes[3]),
                                                  style: TextStyle(
                                                    color: Color(0xFF6C72CB),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
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
                                Member user = snapshot.data!;
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
                                          height: 75,
                                          padding: const EdgeInsets.all(16),
                                          margin: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF6C72CB),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFF6C72CB)
                                                    .withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: Offset(0, -4),
                                              ),
                                            ],
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
                                                                color: DivigoColor
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
                                                                color: DivigoColor
                                                                    .textDefault,
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ))),
                                              const SizedBox(width: 5),
                                              user.profile != null
                                                  ? SizedBox(
                                                      width: 38,
                                                      height: 38,
                                                      child: CachedNetworkImage(
                                                          imageUrl:
                                                              user.profile!,
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
                                                  Text(user.nickname,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      )),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                      'Record ${numberFormat(data['best_score'])}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13.0,
                                                      )),
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

  Widget _buildRankingBadge(int i) {
    if (i < 3) {
      return Image.asset(
        'assets/images/ic_ranking${i + 1}.png',
        width: 34,
        height: 34,
      );
    } else {
      return Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        child: Text(
          (i + 1).toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: DivigoColor.textDefault,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }

  Widget _buildProfileImage(String userKey) {
    return SizedBox(
      width: 38,
      height: 38,
      child: CachedNetworkImage(
        imageUrl: 'https://api.divcow.com/api/profile/${userKey}',
        placeholder: (context, url) =>
            Image.asset('assets/images/ic_profile_default.png'),
        errorWidget: (context, url, error) =>
            Image.asset('assets/images/ic_profile_default.png'),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
