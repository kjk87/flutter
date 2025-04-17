import 'package:flutter/material.dart';

import '../utils/colors.dart';

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
              color: DivigoColor.textDefault,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            )),
      ),

    ],
  );
}
