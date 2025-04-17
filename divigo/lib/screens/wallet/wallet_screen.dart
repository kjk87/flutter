import 'dart:developer';

import 'package:divigo/common/components/format.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/models/vesting.dart';
import 'package:divigo/screens/home/home_screen.dart';
import 'package:divigo/screens/reward/reward_screen.dart';
import 'package:flutter/material.dart';
import '../../common/utils/solanaWalletUtil.dart';
import '../../widgets/wallet/wallet_connect_card.dart';
import '../../widgets/wallet/crypto_list_item.dart';
import '../../widgets/wallet/vesting_info_card.dart';
import '../../core/localization/app_localization.dart';
import '../../widgets/shop/shop_item_card.dart';
import '../../models/shop_item.dart';
import '../../screens/shop/shop_detail_screen.dart';
import '../../widgets/wallet/point_balance_card.dart';
import '../../screens/wallet/token_detail_screen.dart';
import '../../screens/wallet/vesting_detail_screen.dart';
import '../../widgets/wallet/vesting_list_item.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with WidgetsBindingObserver, TabAwareWidget {
  late Future<List<Product>> futureItems;
  bool isWalletConnected = false;
  final GlobalKey<PointBalanceCardState> _pointBalanceKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isWalletConnected =
        SolanaWalletUtil.instance.state == WalletConnectionStatus.connected;
    print('isWalletConnected : $isWalletConnected');
    futureItems = fetchShopItems();
    _pointBalanceKey.currentState?.refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isWalletConnected =
          SolanaWalletUtil.instance.state == WalletConnectionStatus.connected;
      print('isWalletConnected : $isWalletConnected');
      futureItems = fetchShopItems();
      _pointBalanceKey.currentState?.refresh();
    }
  }

  @override
  void onTabChanged(bool isSelected) {
    if (isSelected) {
      isWalletConnected =
          SolanaWalletUtil.instance.state == WalletConnectionStatus.connected;
      print('isWalletConnected : $isWalletConnected');
      futureItems = fetchShopItems();
      _pointBalanceKey.currentState?.refresh();
    }
  }

  Future<List<Product>> fetchShopItems() async {
    final Map<String, dynamic> params = {'paging[page]': 1, 'paging[limit]': 4};

    final list =
        await httpListWithCode(path: '/product', queryParameters: params);
    return list
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<Vesting>> fetchVestingList(String address) async {
    final Map<String, dynamic> params = {'address': address};

    final list = await httpListWithCode(
        path: '/token/vestingList', queryParameters: params);
    return list
        .map((json) => Vesting.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  void _handleWalletConnect() {}

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);

    final List<RewardItem> rewardItems = [
      RewardItem(
        title: local.get('miniGame'),
        subtitle: local.get('miniGameDesc'),
        icon: Icons.sports_esports,
        route: '/reward/mini-game',
        colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
      ),
      RewardItem(
        title: local.get('pedometer'),
        subtitle: local.get('pedometerDesc'),
        icon: Icons.directions_walk,
        route: '/reward/pedometer',
        colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
      ),
      RewardItem(
        title: local.get('numberBaseBall'),
        subtitle: local.get('numberBaseBallDesc'),
        icon: Icons.casino,
        route: '/games/number-baseball',
        colors: [Color(0xFF6C72CB), Color(0xFFCB69C1)],
      ),
      RewardItem(
        title: local.get('rememberPattern'),
        subtitle: local.get('rememberPatternDesc'),
        icon: Icons.grid_4x4,
        route: '/games/pattern-memory',
        colors: [Color(0xFFFF5E62), Color(0xFFFF9966)],
      ),
      RewardItem(
        title: local.get('attendance'),
        subtitle: local.get('attendanceDesc'),
        icon: Icons.calendar_today,
        route: '/reward/attendance',
        colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
      ),
      RewardItem(
        title: local.get('inviteFriends'),
        subtitle: local.get('inviteFriendsDesc'),
        icon: Icons.people,
        route: '/reward/invite',
        colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
      ),
      RewardItem(
        title: local.get('channelSubscribe'),
        subtitle: local.get('channelSubscribeTitle'),
        icon: Icons.emoji_events,
        route: '/reward/channel',
        colors: [Color(0xFFFF8C3B), Color(0xFFFF6365)],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              // futureItems = fetchShopItems();
            });
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (!isWalletConnected)
                WalletConnectCard(onConnect: () {
                  print('onConnect');
                  setState(() {
                    isWalletConnected = SolanaWalletUtil.instance.state ==
                        WalletConnectionStatus.connected;
                  });
                }),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/more/point-history');
                },
                child: PointBalanceCard(key: _pointBalanceKey),
              ),
              const SizedBox(height: 12),
              if (isWalletConnected) ...[
                CryptoListItem(
                    symbol: 'DIV',
                    name: 'DIVCHAIN',
                    amount: SolanaWalletUtil
                                .instance.walletConnectionInfo?.balance !=
                            null
                        ? numberFormat(SolanaWalletUtil
                            .instance.walletConnectionInfo?.balance)
                        : '0.0',
                    dollarValue: '0',
                    icon: Image.asset(
                      'assets/images/ic_divc_circle.png',
                      width: 40,
                      height: 40,
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //       const TokenDetailScreen(symbol: 'DIV')),
                      // );
                    }),
                // 현재 코드를 이렇게 수정하세요
                FutureBuilder<List<Vesting>>(
                  future: fetchVestingList(SolanaWalletUtil
                      .instance.walletConnectionInfo!.publicKey),
                  // future: fetchVestingList('rcv1WjRHfr5Pngetx4p6JRYjBskKRbQUrCFrRiGGr7s'),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Vesting>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF6C72CB)),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('오류 발생: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      List<Vesting> list = snapshot.data!;
                      if (list.isEmpty) {
                        return SizedBox.shrink();
                      }

                      return Column(
                        children: list.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;

                          return Column(
                            children: [
                              const SizedBox(height: 8),
                              VestingListItem(
                                name: item.name,
                                depositedAmount: item.depositedAmount,
                                withdrawnAmount: item.withdrawnAmount,
                                period: item.period,
                                amountPerPeriod: item.amountPerPeriod,
                                cliffAmount: item.cliffAmount,
                                cliff: item.cliff,
                                start: item.start,
                                icon: Image.asset(
                                  'assets/images/ic_divc_round.png',
                                  width: 40,
                                  height: 40,
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const VestingDetailScreen()
                                  //   ),
                                  // );
                                },
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: rewardItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pushNamed(context, item.route),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: item.colors,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontFamily: 'CabinetGrotesk',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.subtitle,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey[400],
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index < rewardItems.length - 1)
                          Divider(
                            height: 1,
                            color: Colors.grey[200],
                            indent: 16,
                            endIndent: 16,
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // 쇼핑 아이템 섹션
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       local.get('shopItems'),
              //       style: const TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black87,
              //       ),
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, '/shop');
              //       },
              //       child: Text(
              //         local.get('seeMore'),
              //         style: TextStyle(
              //           color: Colors.blue[400],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),

              // 쇼핑 아이템 그리드
              // FutureBuilder<List<Product>>(
              //   future: futureItems,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const SizedBox(
              //         height: 200,
              //         child: Center(
              //           child: CircularProgressIndicator(
              //             color: Colors.blue,
              //           ),
              //         ),
              //       );
              //     }
              //
              //     if (snapshot.hasError || !snapshot.hasData) {
              //       return const SizedBox();
              //     }
              //
              //     return GridView.count(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       crossAxisCount: 2,
              //       childAspectRatio: 0.75,
              //       mainAxisSpacing: 16,
              //       crossAxisSpacing: 16,
              //       children: snapshot.data!
              //           .map((item) => ShopItemCard(
              //                 item: item,
              //                 onTap: () {
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) => ShopDetailScreen(
              //                         seqNo: item.seqNo,
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               ))
              //           .toList(),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
