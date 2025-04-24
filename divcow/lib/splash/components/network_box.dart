import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/splash/components/transparent_button.dart';
import 'package:flutter/material.dart';
import 'package:divcow/splash/components/linear_button.dart';
import 'package:easy_localization/easy_localization.dart';

networkBox(void Function(bool click) changeNetwork) {
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
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Image.asset('assets/images/splash_network.png', height: 100, width: 100,),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              tr('networkWrong'),
              textAlign: TextAlign.center,
              style: TextStyle(color: DivcowColor.textDefault, fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Text(
              tr('networkWrongTry'),
              textAlign: TextAlign.center,
              style: TextStyle(color: DivcowColor.textDefault, fontSize: 13)
            ),
          ),
          Row(
            children: [
              splashTransparentButton(tr('cancel'), 35, [15, 0, 5, 30], changeNetwork),
              splashLinearButton(tr('confirmed'), 35, [5, 0, 15, 30], changeNetwork),
            ],
          )

        ],
      )
    )
  );
}
