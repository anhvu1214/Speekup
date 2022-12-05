import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../../../contants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Text Area
        Container(
          height: 200,
          margin: EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: op20BlackColor)),
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                hintText: "Gõ văn bản cần phát ở đây.",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16)),
          ),
        ),
        //Buttons
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Save button
            OutlinedButton(
              onPressed: () {},
              child: Text(
                "Lưu câu",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(148, 40),
                  primary: primaryColor,
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text(
                "Phát văn bản",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(148, 40),
                  primary: Colors.white,
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ],
        )
      ],
    );
  }
}
