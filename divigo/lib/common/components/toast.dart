import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

toast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,  // 토스트 뜨는 시간 얼마나 길게 할 지 (Android)
    gravity: ToastGravity.BOTTOM,  // 토스트 위치 어디에 할 것인지
    timeInSecForIosWeb:  1,  // 토스트 뜨는 시간 얼마나 길게 할 지 (iOS & Web)
    textColor: Colors.white,
    fontSize: 12.0,
  );
}