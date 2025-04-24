import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

appBarHeader({required onPressBack, required text}) {
  return AppBar(
    centerTitle: false,
    leadingWidth: 0,
    titleSpacing: 0,
    backgroundColor: DivcowColor.background,
    title:   Container(
      padding: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              onPressBack();
            },
            child: Image.asset('assets/images/ic_back.png',width: 34,height: 34,),
          ),
          SizedBox(width: 15),
          Text(text, style: TextStyle(color: DivcowColor.textDefault, fontSize: 18.0, fontWeight: FontWeight.w700,)),
        ],
      ),
    )
  );
}