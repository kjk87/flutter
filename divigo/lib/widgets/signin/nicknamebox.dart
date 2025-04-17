import 'package:flutter/material.dart';

signupNicknamebox(
    String title,
    List<double> pad,
    String availableSentence,
    String rejectSentence,
    dynamic reject,
    void Function(String text) onChange,
    void Function() onPress,
    [TextEditingController? controller]) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: EdgeInsets.fromLTRB(pad[0], pad[1], pad[2], pad[3]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: Stack(
              children: [
                TextField(
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1,
                    letterSpacing: 0.5,
                  ),
                  controller: controller,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: reject == null
                            ? Colors.blue
                            : reject
                                ? Colors.red[400]!
                                : Colors.green[400]!,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.only(
                      left: 16,
                      right: 90,
                      top: 14,
                      bottom: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  cursorColor: Colors.blue,
                  onChanged: (text) {
                    onChange(text);
                  },
                ),
                Positioned(
                  right: 4,
                  top: 6,
                  bottom: 6,
                  child: Container(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: onPress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        minimumSize: Size(0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Check',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (reject != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                reject ? rejectSentence : availableSentence,
                style: TextStyle(
                  color: reject ? Colors.red[400] : Colors.green[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
