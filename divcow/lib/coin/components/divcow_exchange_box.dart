import 'package:divcow/common/components/circleIndicator.dart';
import 'package:divcow/common/components/format.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/splash/components/login_button.dart';
import 'package:divcow/splash/components/transparent_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

divcowExchangeBox(int exchangeDivCow, void Function(bool isExchange) click) {
  return Column(
    children: [
      Flexible(flex: 1, child: Container(color: const Color(0x80000000))),
      Container(
          decoration: const BoxDecoration(
            color: Color(0x80000000),
          ),
          child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19), topRight: Radius.circular(19)),
                  color: DivcowColor.popup),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: Image.asset(
                      'assets/images/ic_divcow_coin.png',
                      width: 140,
                      height: 140,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      tr('divSwapPopup', args: [numberFormat(exchangeDivCow)]),
                      style: const TextStyle(fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xffF47321),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/ic_point_s.png',
                              width: 20,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 5),
                            Text(numberFormat((exchangeDivCow*100000)),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: DivcowColor.textDefault,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                )),

                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/images/ic_exchange_arrow.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/ic_divcow_coin_s.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 5),
                            Text(numberFormat(exchangeDivCow),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: DivcowColor.textDefault,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                )),

                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: const GradientBoxBorder(
                                gradient: LinearGradient(
                                    colors: [Color(0xff6A11CB), Color(0xff2575FC)]),
                                width: 1,
                              ),
                            ),
                            child: SizedBox(
                              height: 56,
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    click(false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: DivcowColor.textDefault,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  child: ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) => const LinearGradient(
                                        colors: [
                                          Color(0xff6A11CB),
                                          Color(0xff2575FC)
                                        ]).createShader(
                                      Rect.fromLTWH(
                                          0, 0, bounds.width, bounds.height),
                                    ),
                                    child: const Text('Cancel',
                                        style: TextStyle(fontSize: 15)),
                                  )),
                            )),
                      ),
                      SizedBox(width: 10,),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            click(true);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 56,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.25, 1.0],
                                colors: [Color(0xff6A11CB), Color(0xff2575FC)],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Text('Exchange',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              )))
    ],
  );
}
