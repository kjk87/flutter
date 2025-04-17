import 'package:cached_network_image/cached_network_image.dart';
import 'package:divigo/common/components/format.dart';
import 'package:divigo/common/utils/colors.dart';
import 'package:flutter/material.dart';

Widget itemInvitationHistory(dynamic item) {
  return Column(
    children: [
      const SizedBox(height: 20),
      Row(children: [
        SizedBox(
          width: 38,
          height: 38,
          child: CachedNetworkImage(
              imageUrl: 'https://api.divcow.com/api/profile/${item['userKey']}',
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
            item['nickname'],
            style: const TextStyle(
              color: DivigoColor.textDefault,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            )),
        const Spacer(),
        Text(formatDate(item['regDatetime']),
            style: const TextStyle(
              color: DivigoColor.textDefault,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ]),
      const SizedBox(height: 10),
      Container(
        decoration: const BoxDecoration(
        color: Color(0xffffffff),
      ),
        height: 1,
      ),
    ],
  );
}
