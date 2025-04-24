import 'package:cached_network_image/cached_network_image.dart';
import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/screen/banner_webview_screen.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

Widget itemBack(BuildContext context, String title) {
  return Row(
    children: [
      InkWell(
        onTap: () {
          Navigator.of(context).pop(false);
        },
        child: Image.asset(
          'assets/images/ic_back.png',
          width: 28,
          height: 28,
        ),
      ),
      const SizedBox(width: 5),
      InkWell(
        onTap: () {
          Navigator.of(context).pop(false);
        },
        child: Text(title,
            style: const TextStyle(
              color: DivcowColor.textDefault,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            )),
      ),

    ],
  );
}
