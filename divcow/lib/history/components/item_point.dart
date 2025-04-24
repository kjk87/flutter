import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/screen/banner_webview_screen.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

Widget itemPoint(dynamic item) {
  return Column(
    children: [
      const SizedBox(height: 20),
      Row(children: [
        const SizedBox(width: 10),
        Text(item['subject'],
            style: const TextStyle(
              color: DivcowColor.textDefault,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatDate(item['regDatetime']),
                style: const TextStyle(
                  color: DivcowColor.textDefault,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 5),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff3E407C),
                borderRadius: BorderRadius.all(
                    Radius.circular(23)),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/ic_game_coin.png',
                    width: 20, height: 20,),
                  const SizedBox(width: 5),
                  Text((item['type'] == 'charge' || item['type'] == 'provide') ? numberFormat(item['point']) : '- ${numberFormat(item['point'])}',
                      style: const TextStyle(
                        color: DivcowColor.textDefault,
                        fontSize: 10.0,
                      )),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
      ]),
      const SizedBox(height: 10),
      Container(
        margin: const EdgeInsets.only(
            left: 10, top: 0, right: 10, bottom: 0),
        decoration: const BoxDecoration(
        color: Color(0xffffffff),
      ),
        height: 0.5,
      ),
    ],
  );
}
