import 'package:flutter/material.dart';

alertLinearButton(
    String text, double height, List<double> num, void Function() changeState) {
  return Expanded(
      child: Padding(
          padding: EdgeInsets.fromLTRB(num[0], num[1], num[2], num[3]),
          child: Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.pink, Colors.redAccent]),
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      changeState();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    )),
              ))));
}
