import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/splash/components/transparent_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:divcow/splash/components/linear_button.dart';

watingLeaveBox(void Function(bool click) changeElective) {
  return Container(
    decoration: const BoxDecoration(
      color: Color.fromRGBO(0, 0, 0, 0.4)
    ),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(19),
            topRight: Radius.circular(19)
          ),
          color: DivcowColor.popup
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 20),
            child: Text(
              tr('waitingLeave'),
              textAlign: TextAlign.left,
              style: TextStyle(color: DivcowColor.textDefault, fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ),
          Row(
            children: [
              splashTransparentButton(tr('update'), 35, [15, 0, 5, 30], changeElective),
              splashLinearButton(tr('confirm'), 35, [5, 0, 15, 30], changeElective),
            ],
          )

        ],
      )
    )
  );
}
