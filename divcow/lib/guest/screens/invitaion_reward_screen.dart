import 'dart:io';

import 'package:divcow/common/components/item_back.dart';
import 'package:divcow/common/components/toast.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/guest/screens/invitation_history_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../common/utils/loginInfo.dart';

class InvitaionRewardScreen extends StatelessWidget {
  const InvitaionRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DivcowColor.background,
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(
                    left: 15, top: 0, right: 15, bottom: 15),
                decoration: const BoxDecoration(
                  color: DivcowColor.background,
                ),
                child: FutureBuilder(
                    future: getUser(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        dynamic user = snapshot.data!;
                        return Stack(
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
                                          left: 0,
                                          top: 20,
                                          right: 0,
                                          bottom: 10),
                                      child: itemBack(
                                          context, tr('invitationReward'))),
                                  actions: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const InvitationHistoryScreen()));
                                      },
                                      child: const Text('History',
                                          style: TextStyle(
                                            color: DivcowColor.textDefault,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                  ],
                                ),
                                SliverToBoxAdapter(
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: DivcowColor.popup,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(tr('InvitationCheckDesc1'),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: DivcowColor.textDefault,
                                                fontSize: 28.0,
                                                fontWeight: FontWeight.w700,
                                              )),
                                          Text(tr('InvitationCheckDesc2'),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: DivcowColor.textDefault,
                                                fontSize: 12.0,
                                                // fontWeight: FontWeight.w700,
                                              )),
                                          const SizedBox(height: 10),
                                          Image.asset(
                                            'assets/images/img_invitation_1.png',
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                          ),
                                          const SizedBox(height: 15),
                                          Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                color: DivcowColor.card,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/ic_caution.png',
                                                    width: 20,
                                                    height: 20,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Text(
                                                        tr(
                                                            'InvitationCheckDesc3'),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: const TextStyle(
                                                          color: DivcowColor
                                                              .textDefault,
                                                          fontSize: 12.0,
                                                          // fontWeight: FontWeight.w700,
                                                        )),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.all(5),
                                ),
                                SliverToBoxAdapter(
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: DivcowColor.popup,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('(TIP)',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: DivcowColor.textDefault,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w700,
                                              )),
                                          SizedBox(height: 10),
                                          Image.asset(
                                            'assets/images/img_invitation_2.png',
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(tr('InvitationCheckDesc4'),
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                color: DivcowColor.textDefault,
                                                fontSize: 12.0,
                                                // fontWeight: FontWeight.w700,
                                              )),
                                        ],
                                      )),
                                ),
                                const SliverPadding(
                                  padding: EdgeInsets.all(5),
                                ),
                                SliverToBoxAdapter(
                                  child: Text(tr('ReferralLink'),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: DivcowColor.textDefault,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700,
                                      )),
                                ),
                                const SliverPadding(
                                  padding: EdgeInsets.all(5),
                                ),
                                SliverToBoxAdapter(
                                    child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: DivcowColor.popup,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Text(
                                      tr('shareUrl', args: [user['userKey']]),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: DivcowColor.textDefault,
                                        fontSize: 12.0,
                                        // fontWeight: FontWeight.w700,
                                      )),
                                )),
                                const SliverPadding(
                                  padding: EdgeInsets.all(50),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 44,
                              child: Row(children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: tr('shareUrl',
                                              args: [user['userKey']])));
                                      if (Platform.isIOS) {
                                        toast(tr('copiedtoClipboard'));
                                      }

                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: [0.0, 1.0],
                                          colors: DivcowColor.linearMain,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/ic_copy.png',
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.fill,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(tr('CopyLink'),
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
                                const SizedBox(width: 15),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Share.share(
                                          tr('shareUrl',
                                              args: [user['userKey']]),
                                          subject: tr('inviteDesc'));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: [0.0, 1.0],
                                          colors: DivcowColor.linearMain,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/ic_share.png',
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.fill,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(tr('Share'),
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
                              ]),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }))));
  }
}
