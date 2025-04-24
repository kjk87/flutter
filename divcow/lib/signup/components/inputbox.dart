import 'package:divcow/common/utils/colors.dart';
import 'package:flutter/material.dart';

signupInputbox(String title, List<double> pad, void Function(String text) onChange, [String? description, TextEditingController? controller]) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: EdgeInsets.fromLTRB(pad[0], pad[1], pad[2], pad[3]),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(title, textAlign: TextAlign.start, style: const TextStyle(color: DivcowColor.textDefault, fontSize: 11),)
          ),
          const SizedBox(height: 8,),
          SizedBox(
            height: 32,
            child: TextField(
              style: const TextStyle(fontSize: 12, color: DivcowColor.textDefault, height: 1),
              controller: controller,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(37, 117, 252, 1),
                    width: 1
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(10),
                filled: true,
                fillColor: DivcowColor.card
              ),
              cursorColor: Colors.amber,
              onChanged: (text) {
                onChange(text);
              },
            ),
          ),
          description == null ?
          const SizedBox(height: 0,)
          :
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Text(description, textAlign: TextAlign.start, style: TextStyle(color: DivcowColor.textDefault, fontSize: 11)),
            )
          ),
        ],
      ),
    ),
  );
}