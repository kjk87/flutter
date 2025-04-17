import 'package:flutter/material.dart';

signupLinearButton(
    String text, double height, List<double> num, void Function() onPress) {
  return SizedBox(
      child: Padding(
          padding: EdgeInsets.fromLTRB(num[0], num[1], num[2], num[3]),
          child: Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.indigoAccent, Colors.lightBlueAccent]),
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                width: double.infinity,
                height: height,
                child: ElevatedButton(
                    onPressed: () {
                      onPress();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.indigoAccent,
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
