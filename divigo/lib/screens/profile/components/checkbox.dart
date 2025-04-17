import 'package:flutter/material.dart';

inquireCheckbox(title, checked, onPress) {
  return SizedBox(
      child: GestureDetector(
          onTap: () {
            onPress();
          },
          child: Row(children: [
            checked
                ? Image.asset(
                    'assets/images/inquire_check.png',
                    width: 18,
                  )
                : Image.asset(
                    'assets/images/inquire_uncheck.png',
                    width: 18,
                  ),
            SizedBox(
              width: 10,
            ),
            Text(title,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ])));
}
