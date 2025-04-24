import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/splash/components/login_button.dart';
import 'package:flutter/material.dart';

loginBox(void Function(String platform) clickLogin) {
  return Container(
    decoration: const BoxDecoration(
      color: Color.fromRGBO(0, 0, 0, 0.4)
    ),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(19),
            topRight: Radius.circular(19)
          ),
          color: DivcowColor.popup
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Image.asset('assets/images/splash_login_logo.png'),
          ),
          SizedBox(child: splashLoginButton('demo', 40, 'DEMO LOGIN', [10, 10, 10, 10], clickLogin)),
          SizedBox(child: splashLoginButton('google', 40, 'Login With Google', [10, 10, 10, 10], clickLogin)),
          SizedBox(child: splashLoginButton('apple', 40, 'Login With Apple', [10, 10, 10, 30], clickLogin)),
        ],
      )
    )
  );
}
