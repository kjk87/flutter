import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../widgets/common/banner_webview_screen.dart';

Widget imageSlider(List<dynamic> list) {
  return CarouselSlider.builder(
      itemCount: list.length,
      itemBuilder: (context, index, realIndex) {
        final banner = list[index];
        final path = banner['image'].toString();
        return
          InkWell(
            onTap: () {
              final moveType = banner['moveType'].toString();
              if(moveType == 'outer'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BannerWebviewScreen(banner['title'], banner['outerUrl'])));
              }else if(moveType == 'inner'){

              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(path),
                ),
              ),
              margin:
              const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
              width: double.infinity,
            )
          );
      },
      options: CarouselOptions(
        initialPage: 0,
        viewportFraction: 1,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) => {},
      ));
}
