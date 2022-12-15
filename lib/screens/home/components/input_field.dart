import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../contants.dart';

Widget buildInputField(TextEditingController ctl, String hintText) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: op20BlackColor)),
    constraints: BoxConstraints(maxHeight: 300),
    child: TextField(
      controller: ctl,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: op40BlackColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10)),
    ),
  );
}
