import 'package:flutter/material.dart';

managementDatebox(context, String title, List<double> pad,
    void Function(String text) onChange, bool disable,
    [String? description = null, String? defaultValue = '']) {
  var date = '';
  if (defaultValue != null && defaultValue != '') {
    date += defaultValue.substring(4, 6);
    date += '/';
    date += defaultValue.substring(6, 8);
    date += '/';
    date += defaultValue.substring(0, 4);
  }

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
              child: GestureDetector(
                onTap: () async {
                  var datetime = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1000),
                      lastDate: DateTime(2100));
                  if (datetime != null) {
                    var date = datetime.toString();
                    onChange(date.substring(0, 4) +
                        date.substring(5, 7) +
                        date.substring(8, 10));
                  }
                },
                child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(62, 64, 124, 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Text(
                          date,
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/images/setting_arrow.png',
                          width: 20,
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
              )),
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
