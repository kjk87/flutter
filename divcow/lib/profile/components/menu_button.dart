import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

menuButton(image, double imageSize, title, double fontSize, List<double> pad, onPress) {
  return InkWell(
    onTap: () {onPress();},
    child: Padding(
      padding: EdgeInsets.fromLTRB(pad[0], pad[1], pad[2], pad[3]),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: DivcowColor.card,
              borderRadius: BorderRadius.all(
                Radius.circular(5)
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Image.asset(image, width: imageSize,),
            )
          ),
          SizedBox(width: 10,),
          Text(title, style: TextStyle(fontSize: fontSize, color: DivcowColor.textDefault, fontWeight: FontWeight.bold),)
        ],
      ),
    )
  );
}