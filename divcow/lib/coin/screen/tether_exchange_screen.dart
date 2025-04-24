import 'dart:developer';
import 'dart:io';

import 'package:divcow/coin/components/tether_exchange_box.dart';
import 'package:divcow/common/components/circleIndicator.dart';
import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/components/item_back.dart';
import 'package:divcow/common/components/toast.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/common/utils/loginInfo.dart';
import 'package:divcow/common/utils/walletUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_appkit/reown_appkit.dart';

class TetherExchangeScreen extends StatefulWidget {
  const TetherExchangeScreen({super.key});

  @override
  State<TetherExchangeScreen> createState() => _TetherExchangeScreenState();
}

class _TetherExchangeScreenState extends State<TetherExchangeScreen> {
  String? address;
  int exchangeTether = 0;
  bool popupVisible = false;
  bool showProgress = false;
  late Future<dynamic> futureUser;

  @override
  void initState() {
    super.initState();

    WalletUtil.instance.appKitModal.removeListener(callback);
    WalletUtil.instance.appKitModal.addListener(callback);

    _fetchUser();
  }

  void _fetchUser() {
    futureUser = getUser(context);
  }

  void callback() {
    setState(() {});
  }

  @override
  void dispose() {
    WalletUtil.instance.appKitModal.removeListener(callback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (WalletUtil.instance.appKitModal.isConnected) {
      address = WalletUtil.instance.appKitModal.session!.getAddress(NetworkUtils.solana);
    }
    var textController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: DivcowColor.background,
          body: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff14154E),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    FutureBuilder(
                        future: futureUser,
                        builder:
                            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            dynamic user = snapshot.data!;
                            return CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  centerTitle: false,
                                  leadingWidth: 0,
                                  titleSpacing: 0,
                                  pinned: true,
                                  backgroundColor: const Color(0xff14154E),
                                  title: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 20, right: 10, bottom: 10),
                                      child:
                                      itemBack(context, tr('TetherTransition'))),
                                ),
                                SliverToBoxAdapter(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/images/img_ton_wallet_banner.png'),
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 0, right: 10, bottom: 10),
                                    width: double.infinity,
                                    height: 160,
                                  ),
                                ),
                                const SliverPadding(
                                  padding: EdgeInsets.all(5),
                                ),
                                SliverToBoxAdapter(
                                    child: Visibility(
                                      visible: WalletUtil.instance.walletInit,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 0, right: 15, bottom: 0),
                                        height: 32,
                                        child: TextField(
                                          key: UniqueKey(),
                                          controller: textController,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: DivcowColor.textDefault,
                                              height: 1),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color:
                                                    Color.fromRGBO(37, 117, 252, 1),
                                                    width: 1)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            isDense: true,
                                            contentPadding: const EdgeInsets.all(10),
                                            filled: true,
                                            fillColor: DivcowColor.card,
                                            hintText: tr('hintInputTether'),
                                            hintStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.amber,
                                          onChanged: (text) {
                                            if (text.isNotEmpty) {
                                              if (int.parse(text) > user['tether']) {
                                                textController.text =
                                                    user['tether'].toString();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    )),
                                const SliverPadding(padding: EdgeInsets.all(5)),
                                SliverToBoxAdapter(
                                  child: Visibility(
                                      visible: WalletUtil.instance.walletInit,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/ic_tether_s.png',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(numberFormat(user['tether']),
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                    color: DivcowColor.textDefault,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ],
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              textController.text =
                                                  user['tether'].toString();
                                            },
                                            child: Text(tr('maximumInputs'),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  color: Color(0xffE43935),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      )),
                                )
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                    Visibility(
                      visible: WalletUtil.instance.walletInit && !WalletUtil.instance.appKitModal.isConnected,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 0, right: 15, bottom: 15),
                        height: 44,
                        child: InkWell(
                          onTap: () {
                            WalletUtil.instance.appKitModal.openModalView();
                          },
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.0, 1.0],
                                colors: [Color(0xff6A11CB), Color(0xff2575FC)],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic_wallet_connect.png',
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(width: 5),
                                Text(tr('connectYourWallet'),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: DivcowColor.textDefault,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: WalletUtil.instance.appKitModal.isConnected,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 0, right: 15, bottom: 15),
                        height: 122,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await WalletUtil.instance.appKitModal.disconnect();
                                    setState(() {});
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 56,
                                    width: 56,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [0.25, 1.0],
                                        colors: [
                                          Color(0xff6A11CB),
                                          Color(0xff2575FC)
                                        ],
                                      ),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Image.asset(
                                      'assets/images/ic_disconnect.png',
                                      width: 25,
                                      height: 25,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: const GradientBoxBorder(
                                          gradient: LinearGradient(colors: [
                                            Color(0xff6A11CB),
                                            Color(0xff2575FC)
                                          ]),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              address != null
                                                  ? '${address!.substring(0, 10)}....${address!.substring(address!.length - 10)}'
                                                  : '',
                                              style: const TextStyle(
                                                  fontSize: 15, color: Colors.white)),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(
                                                  ClipboardData(text: address!));
                                              if (Platform.isIOS) {
                                                toast(tr('copiedtoClipboard'));
                                              }
                                            },
                                            child: Image.asset(
                                              'assets/images/ic_copy2.png',
                                              width: 25,
                                              height: 25,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                if (textController.text.isNotEmpty) {
                                  exchangeTether = textController.text.toInt()!;
                                } else {
                                  exchangeTether = 0;
                                }

                                if (!showProgress && exchangeTether >= 10) {
                                  setState(() {
                                    popupVisible = true;
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  });
                                } else {
                                  String msg = '';
                                  if (exchangeTether > 0) {
                                    msg = tr('tetherToast1');
                                  } else {
                                    msg = tr('tetherToast2');
                                  }
                                  toast(msg);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 56,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: [0.25, 1.0],
                                    colors: [Color(0xff6A11CB), Color(0xff2575FC)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/ic_exchange_tether.png',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(tr('ExchangeTether'),
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.white))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: popupVisible,
                      child: tetherExchangeBox(exchangeTether, (isExchange) async {
                        setState(() {
                          popupVisible = false;
                          if (isExchange) {
                            showProgress = true;
                          }
                        });
                        if (isExchange) {
                          var params = {
                            'type': 'usdt',
                            'address': address,
                            'amount': exchangeTether
                          };
                          await httpPost(path: '/member/swapCoin', params: params);
                          toast(tr('ExchangeCompleted'));
                          setState(() {
                            showProgress = false;
                            _fetchUser();
                          });
                        }
                      }),
                    ),
                    Visibility(
                      visible: showProgress,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: double.infinity,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
