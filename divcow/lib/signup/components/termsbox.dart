import 'package:divcow/common/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget termsbox({required bool require, required bool check, required String title, required void Function(bool check) onCheck, required void Function() onPressView}) {

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              onCheck(!check);
            },
            child: 
              check ? 
              Image.asset('assets/images/signup_terms_active.png')
              :
              Image.asset('assets/images/signup_terms_inactive.png')
          ),
          SizedBox(width: 10,),
          Text(title + (require ? ' (Required)' : ' (optional)'), textAlign: TextAlign.start, style: TextStyle(color: DivcowColor.textDefault, fontSize: 11)),
          Spacer(),
          TextButton(
            onPressed: onPressView, 
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              tr('ViewContent'),
              textAlign: TextAlign.start, 
              style: TextStyle(color: DivcowColor.textDefault, fontSize: 11, decoration: TextDecoration.underline, decorationColor: DivcowColor.textDefault),
            ),
          )
        ],
      ),
    );

}