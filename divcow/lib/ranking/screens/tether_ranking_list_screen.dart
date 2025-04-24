import 'package:cached_network_image/cached_network_image.dart';
import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/components/item_back.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TetherRankingListScreen extends StatelessWidget {
  const TetherRankingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                decoration: const BoxDecoration(
                  color: DivcowColor.background,
                ),
                child: FutureBuilder(
                    future: httpList(path: '/ranking/tether'),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> list = snapshot.data!;

                        if(list.isEmpty){
                          return Scaffold(
                            appBar: AppBar(
                              centerTitle: false,
                              leadingWidth: 0,
                              titleSpacing: 0,
                              backgroundColor: DivcowColor.background,
                              title: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 20, right: 10, bottom: 10),
                                  child: itemBack(context, tr('TetherRanking'))
                              ),
                            ),
                            body: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: DivcowColor.background,
                              ),
                              child: Text(tr('TetherRankingNotExist'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: DivcowColor.textDefault,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                          );
                        }

                        return CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              centerTitle: false,
                              leadingWidth: 0,
                              titleSpacing: 0,
                              pinned: true,
                              backgroundColor: DivcowColor.background,
                              title: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 20, right: 10, bottom: 10),
                                  child: itemBack(context, tr('TetherRanking'))
                              ),
                            ),
                            SliverToBoxAdapter(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/images/img_tether_ranking_banner.png'),
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 10, top: 0, right: 10, bottom: 10),
                                  width: double.infinity,
                                  height: 160,
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
                                      borderRadius: BorderRadius.all(
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
                                          alignment:
                                          Alignment.center,
                                          child: Text((i + 1).toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: DivcowColor.textDefault,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ))
                                        ),
                                        SizedBox(
                                          width: 38,
                                          height: 38,
                                          child: CachedNetworkImage(
                                              imageUrl: 'https://api.divcow.com/api/profile/${list[i]['memberTotal']['userKey']}',
                                              placeholder: (context, url) => Image.asset('assets/images/ic_profile_default.png'),
                                              errorWidget: (context, url, error) => Image.asset('assets/images/ic_profile_default.png'),
                                              imageBuilder: (context, imageProvider) => Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                              )
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                            list[i]['memberTotal']
                                            ['nickname'],
                                            style: const TextStyle(
                                              color: DivcowColor.textDefault,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700,
                                            )),
                                        Spacer(),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xffB5E7DA),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(23)),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/ic_my_ranking_tether.png',
                                                width: 24,
                                                height: 24,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                  numberFormat(list[i]['tether']),
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
                          ],
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                    }))));
  }
}
