import 'package:flutter/material.dart';

managementInputbox(String title, List<double> pad,
    void Function(String text) onChange, bool disable,
    [String? description, TextEditingController? controller]) {
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
            height: 32,
            child: TextField(
              readOnly: disable,
              controller: controller,
              style:
                  const TextStyle(fontSize: 12, color: Colors.white, height: 1),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(37, 117, 252, 1), width: 1)),
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
          ),
          description == null
              ? const SizedBox(
                  height: 0,
                )
              : SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(description,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  )),
        ],
      ),
    ),
  );
}
