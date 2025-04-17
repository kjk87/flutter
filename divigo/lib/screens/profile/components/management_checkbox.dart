import 'package:divigo/core/localization/app_localization.dart';
import 'package:flutter/material.dart';

Widget managementCheckbox(
    BuildContext context,
    String title,
    List<double> margin,
    Function(String) onChange,
    bool readOnly,
    String hint,
    String value) {
  return Container(
    margin: EdgeInsets.fromLTRB(margin[0], margin[1], margin[2], margin[3]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(62, 64, 124, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (!readOnly) {
                        onChange(AppLocalization.of(context).get('male'));
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          value == AppLocalization.of(context).get('male')
                              ? 'assets/images/inquire_check.png'
                              : 'assets/images/inquire_uncheck.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          AppLocalization.of(context).get('male'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (!readOnly) {
                        onChange(AppLocalization.of(context).get('female'));
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          value == AppLocalization.of(context).get('female')
                              ? 'assets/images/inquire_check.png'
                              : 'assets/images/inquire_uncheck.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          AppLocalization.of(context).get('female'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
