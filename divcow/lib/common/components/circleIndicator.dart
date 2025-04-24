import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

circleIndicator() {
  return Container(
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: DivcowColor.background,
    ),
    child: const CircularProgressIndicator(
      color: DivcowColor.textDefault,
    ),
  );
}