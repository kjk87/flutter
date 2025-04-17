import 'package:flutter/material.dart';

signupInputbox(
    String title, List<double> pad, void Function(String text) onChange,
    [String? description, TextEditingController? controller]) {
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
            child: TextField(
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
                    color: Colors.blue,
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
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                ),
              ),
              cursorColor: Colors.blue,
              onChanged: (text) {
                onChange(text);
              },
            ),
          ),
          if (description != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
