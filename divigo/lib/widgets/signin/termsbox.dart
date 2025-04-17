import 'package:flutter/material.dart';

Widget termsbox(
    {required bool require,
    required bool check,
    required String title,
    required void Function(bool check) onCheck,
    required void Function() onPressView}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      InkWell(
          onTap: () {
            onCheck(!check);
          },
          child: check
              ? Image.asset('assets/images/signup_terms_active.png')
              : Image.asset('assets/images/signup_terms_inactive.png')),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: TextButton(
            onPressed: onPressView,
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
            ),
            child: Text(title + (require ? ' (Required)' : ' (optional)'),
                softWrap: true,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 11,
                  height: 1.2,
                ))),
      ),
    ],
  );
}
