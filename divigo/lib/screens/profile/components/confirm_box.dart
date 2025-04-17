import 'package:divigo/core/localization/app_localization.dart';
import 'package:divigo/screens/profile/components/linear_button.dart';
import 'package:divigo/screens/profile/components/transparent_button.dart';
import 'package:flutter/material.dart';

confirmBox(void Function(bool click) changeElective, BuildContext context) {
  final local = AppLocalization.of(context);

  return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.4)),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(19), topRight: Radius.circular(19)),
              color: Color.fromRGBO(39, 37, 100, 1)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 30, 15, 20),
                child: Text(local.get('withdrawal'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  profileTransparentButton(
                      local.get('edit'), 40, [15, 0, 5, 30], changeElective),
                  profileLinearButton(
                      local.get('confirm'), 40, [5, 0, 15, 30], changeElective),
                ],
              )
            ],
          )));
}
