import 'package:cached_network_image/cached_network_image.dart';
import 'package:divigo/common/components/format.dart';
import 'package:divigo/common/utils/colors.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:flutter/material.dart';

import '../../common/components/image_slider.dart';
import '../../core/localization/app_localization.dart';
import '../../models/game_info.dart';
import 'game_ranking_list_screen.dart';

class RankingListScreen extends StatelessWidget {
  const RankingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: httpList(path: '/games/listWithMyAppRanking'),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          final list = snapshot.data!
              .map((json) => Games.fromJson(json as Map<String, dynamic>))
              .toList();
          return Column(
            children: [
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, i) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameRankingListScreen(list[i]),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFF6C72CB).withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF6C72CB).withOpacity(0.12),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: CachedNetworkImage(
                            imageUrl: list[i].image,
                            placeholder: (context, url) => Image.asset(
                                'assets/images/ic_profile_default.png'),
                            errorWidget: (context, url, error) => Image.asset(
                                'assets/images/ic_profile_default.png'),
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
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list[i].name,
                                style: const TextStyle(
                                  color: Color(0xFF14142B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF6C72CB),
                                      Color(0xFFCB69C1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/ic_my_ranking_coin.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      numberFormat(list[i].prize_1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            list[i].ranking == null
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEEEEFF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      AppLocalization.of(context).get('NoRank'),
                                      style: TextStyle(
                                        color: Color(0xFF6C72CB),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : list[i].ranking!.ranking! <= 3
                                    ? Image.asset(
                                        'assets/images/ic_my_ranking${list[i].ranking!.ranking!}.png',
                                        width: 24,
                                        height: 24,
                                      )
                                    : Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF6C72CB),
                                        ),
                                        child: Center(
                                          child: Text(
                                            list[i]
                                                .ranking!
                                                .ranking!
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                            const SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF6C72CB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalization.of(context).get('MyRank'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
