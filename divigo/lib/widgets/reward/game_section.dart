import 'dart:developer';

import 'package:divigo/common/components/format.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/models/game_info.dart';
import 'package:divigo/screens/reward/games/game_webview_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/localization/app_localization.dart';

// 게임 섹션
class GameSection extends StatefulWidget {
  const GameSection({super.key});

  @override
  State<GameSection> createState() => _GameSectionState();
}

class _GameSectionState extends State<GameSection> {
  late Future<List<dynamic>> futureGames;

  @override
  void initState() {
    super.initState();
    futureGames = fetchGames();
  }

  Future<List<Games>> fetchGames() async {
    final list = await httpList(path: '/games');

    final games = list
        .map((json) => Games.fromJson(json as Map<String, dynamic>))
        .toList();
    return games;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futureGames,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('게임이 없습니다'),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final game = snapshot.data![index] as Games;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameWebViewScreen(
                      games: game,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          game.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.games,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Score: ${numberFormat(game.cut_off_score)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// class _GameListBottomSheet extends StatelessWidget {
//   final String title;
//   final List<Color> gradient;
//   final List<GameInfo> games;

//   const _GameListBottomSheet({
//     required this.title,
//     required this.gradient,
//     required this.games,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.7,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: gradient),
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Row(
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(Icons.close, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: games.length,
//               itemBuilder: (context, index) {
//                 final game = games[index];
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   elevation: 4,
//                   shadowColor: gradient[0].withOpacity(0.2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: InkWell(
//                     onTap: () => _startGame(context, game.title),
//                     borderRadius: BorderRadius.circular(16),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       child: Row(
//                         children: [
//                           if (game.image != null)
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.network(
//                                 game.image!,
//                                 width: 80,
//                                 height: 80,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           else
//                             Container(
//                               width: 80,
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(colors: gradient),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Icon(
//                                 game.icon,
//                                 color: Colors.white,
//                                 size: 40,
//                               ),
//                             ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       game.title,
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     if (game.isNew)
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 2,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Colors.blue,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: const Text(
//                                           'NEW',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       )
//                                     else if (game.isHot)
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 2,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Colors.red,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: const Text(
//                                           'HOT',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   game.description,
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontSize: 13,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Icon(Icons.arrow_forward_ios, size: 16),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _startGame(BuildContext context, String gameTitle) {
//     Navigator.pop(context); // 바텀시트 닫기
//     Navigator.pushNamed(
//       context,
//       '/reward/game/${gameTitle.toLowerCase().replaceAll(' ', '_')}',
//     );
//   }
// }
