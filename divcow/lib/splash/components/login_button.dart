import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

splashLoginButton(String platform, double height, String text, List<double> num, void Function(String click) changeState) {
  return 
    Padding(
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
          onPressed: () { changeState(platform); }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: DivcowColor.textDefault,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              platform == 'google' ? 
              Image.asset('assets/images/splash_login_google.png')
              :
              platform == 'apple' ? 
              Image.asset('assets/images/splash_login_apple.png')
              :
              SizedBox(),
              const SizedBox(width: 10,),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          )
        ),
      )
    )
  );
}
