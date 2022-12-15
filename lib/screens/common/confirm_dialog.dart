import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/db/category_table.dart';
import 'package:speekup_v2/model/category.dart';

import '../../contants.dart';

class ConfirmDialog extends StatefulWidget {
  ConfirmDialog(
      {super.key,
      required this.title,
      required this.confirmContent,
      required this.onConfirm,
      this.id = 0});

  final String title;
  final String confirmContent;
  final Function onConfirm;
  final int id;

  @override
  _ConfirmDialog createState() => _ConfirmDialog();
}

class _ConfirmDialog extends State<ConfirmDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.all(70),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(widget.title,
                  style: TextStyle(fontWeight: w600Font, fontSize: 16))),
          Divider(
            height: 1,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            constraints: BoxConstraints(maxHeight: 300),
            child: Text(
              widget.confirmContent,
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            height: 1,
          ),
          SizedBox(
              height: 36,
              child: IntrinsicHeight(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:
                          Text("Hủy", style: TextStyle(color: Colors.black))),
                  VerticalDivider(thickness: 1, width: 1),
                  TextButton(
                      onPressed: () {
                          widget.onConfirm();
                          Navigator.of(context).pop();
                      },
                      child:
                          Text("Có", style: TextStyle(color: primaryColor)))
                ],
              )))
        ],
      ),
    );
  }
}
