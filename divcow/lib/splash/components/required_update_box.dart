import 'package:divcow/common/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:divcow/splash/components/linear_button.dart';

requiredUpdateBox(void Function(bool click) changeRequired) {
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
              tr('requireUpdate'),
              textAlign: TextAlign.center,
              style: TextStyle(color: DivcowColor.textDefault, fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ),
          Row(
            children: [
              splashLinearButton(tr('update'), 35, [15, 5, 15, 25], changeRequired),
            ],
          )

        ],
      )
    )
  );
}
