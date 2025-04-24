import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

Widget bottomBarIcon(String url, String title, bool isSel) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Column(children: [
        Image.asset(url, width: 25, height: 25, fit: BoxFit.fill),
        Container(
            margin: const EdgeInsets.only(left: 0, top: 2, right: 0, bottom: 0),
            child: Text(title,
                style: const TextStyle(
                  color: DivcowColor.textDefault,
                  fontSize: 8.0,
                ))),
      ]),
      isSel
          ? Image.asset('assets/images/gnb_sel.png',
              height: 60, fit: BoxFit.fill)
          : const SizedBox(height: 60),
    ],
  );
}
