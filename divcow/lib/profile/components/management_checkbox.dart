import 'dart:developer';

import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/profile/components/checkbox.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

managementCheckbox(context, String title, List<double> pad, void Function(String text) onChange, bool disable, [String? description = null, String? defaultValue = '']) {
  
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: EdgeInsets.fromLTRB(pad[0], pad[1], pad[2], pad[3]),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(title, textAlign: TextAlign.start, style: const TextStyle(color: DivcowColor.textDefault, fontSize: 13, fontWeight: FontWeight.bold),)
          ),
          const SizedBox(height: 8,),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(
              // color: DivcowColor.card,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Row(
              children: [
                inquireCheckbox(tr('male'), defaultValue == 'male', () {onChange('male');}),
                SizedBox(width: 20,),
                inquireCheckbox(tr('female'), defaultValue == 'female', () {onChange('female');}),
              ],
            )
          )
        ],
      ),
    ),
  );
}