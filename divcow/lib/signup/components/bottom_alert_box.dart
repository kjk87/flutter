import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/signup/components/alert_linear_button.dart';
import 'package:flutter/material.dart';

bottomAlertBox(String title, String buttonText, void Function() onPress) {
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
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: DivcowColor.textDefault, fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ),
          Row(
            children: [
              alertLinearButton(buttonText, 35, [15, 5, 15, 25], onPress),
            ],
          )

        ],
      )
    )
  );
}
