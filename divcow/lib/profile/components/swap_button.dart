import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

swapButton(String image, double imageWidgh, String text, double fontSize, void Function() onPress) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(5, 8, 10, 3),
      child: InkWell(
        onTap: () {
          onPress();
        },
        child: Container(
          width: double.infinity,
          height: 30,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5)
            ),
            gradient: LinearGradient(
              colors: DivcowColor.linearMain
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, width: imageWidgh,),
              SizedBox(width: 5),
              Text(text, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: DivcowColor.textDefault),)
            ],
          ),
        ),
      ) 
    )
  );
}