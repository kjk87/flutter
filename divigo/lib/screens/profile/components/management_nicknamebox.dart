import 'package:divigo/core/localization/app_localization.dart';
import 'package:flutter/material.dart';

managementNicknamebox(
    String title,
    List<double> pad,
    String availableSentence,
    String rejectSentence,
    dynamic reject,
    void Function(String text) onChange,
    void Function() onPress,
    BuildContext context,
    [TextEditingController? controller]) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: EdgeInsets.fromLTRB(pad[0], pad[1], pad[2], pad[3]),
      child: Column(
        children: [
          SizedBox(
              width: double.infinity,
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 52,
            child: Stack(
              children: [
                TextField(
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white, height: 1),
                  controller: controller,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: reject == null
                                  ? Color.fromRGBO(37, 117, 252, 1)
                                  : reject
                                      ? Color.fromRGBO(255, 93, 93, 1)
                                      : Color.fromARGB(255, 37, 252, 91),
                              width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10),
                      filled: true,
                      fillColor: Color.fromRGBO(62, 64, 124, 1)),
                  cursorColor: Colors.amber,
                  onChanged: (text) {
                    onChange(text);
                  },
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          onPress();
                        },
                        style: ElevatedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.only(
                              left: 10, top: 3, right: 10, bottom: 3),
                          backgroundColor: Color.fromRGBO(39, 37, 100, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Text(
                          AppLocalization.of(context).get('check'),
                          style: const TextStyle(
                              color: Color.fromRGBO(119, 245, 174, 1),
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
              width: double.infinity,
              child: reject == null
                  ? Text('', style: TextStyle(fontSize: 11))
                  : reject
                      ? Text(rejectSentence,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 93, 93, 1),
                              fontSize: 11))
                      : Text(availableSentence,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color.fromRGBO(119, 245, 174, 1),
                              fontSize: 11))),
        ],
      ),
    ),
  );
}
