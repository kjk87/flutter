import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

profileTransparentButton(String text, double height, List<double> num, void Function(bool click) changeElective) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.fromLTRB(num[0], num[1], num[2], num[3]),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: const GradientBoxBorder(
            gradient: LinearGradient(
              colors: DivcowColor.linearMain
            ),
            width: 1,
          ),
        ),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () { changeElective(false); }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: DivcowColor.textDefault,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: DivcowColor.linearMain
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(text, style: const TextStyle(fontSize: 15)),
            )
          ),
        )
      )
    )
  );
}
