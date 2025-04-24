import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

profileLinearButton(String text, double height, List<double> num, void Function(bool click) onPress) {
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
          width: double.infinity,
          height: height,
          child: ElevatedButton(
            onPressed: () { onPress(true); }, 
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
