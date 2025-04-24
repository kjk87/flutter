import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDateString = DateFormat('yyyy.MM.dd').format(dateTime);
  return formattedDateString;
}

String numberFormat(dynamic number){
  var f = NumberFormat('###,###,###,###');
  return f.format(number);
}