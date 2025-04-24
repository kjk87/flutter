import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

splashLinearButton(String text, double height, List<double> num, void Function(bool click) changeState) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.fromLTRB(num[0], num[1], num[2], num[3]),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: DivcowColor.linearMain
          ),
          borderRadius: BorderRadius.circular(10)
        ),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () { changeState(true); }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: DivcowColor.textDefault,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          ),
        )
      )
    )
  );
}
