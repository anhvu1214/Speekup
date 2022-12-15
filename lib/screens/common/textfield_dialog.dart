import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/db/category_table.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/screens/common/utils.dart';

import '../../contants.dart';

class TextFieldDialog extends StatefulWidget {
  TextFieldDialog(
      {super.key,
      required this.title,
      required this.initText,
      required this.onSave,
      required this.id,
      this.subtitle,
      this.hintText,
      this.inputHeight});

  final String title;
  final String initText;
  final Function onSave;
  final int id;
  final String? hintText;
  final String? subtitle;
  final double? inputHeight;

  @override
  _TextFieldDialog createState() => _TextFieldDialog();
}

class _TextFieldDialog extends State<TextFieldDialog> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ctlInputCategoryName = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      ctlInputCategoryName.text = widget.initText;
    });
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
          widget.subtitle == null
              ? Container()
              : Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(widget.subtitle as String,
                      style: TextStyle(fontSize: 14, fontWeight: w400Font)),
              ),
          Container(
            height: widget.inputHeight ?? null,
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: op20BlackColor)),
            constraints: BoxConstraints(maxHeight: 300),
            child: TextField(
              controller: ctlInputCategoryName,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  hintText: widget.hintText ?? "Nhập tên bộ câu mới",
                  hintStyle: TextStyle(fontSize: 14, color: op40BlackColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10)),
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
                        if (ctlInputCategoryName.text == '') {
                          //Alert input is empty
                          showToast("Không được để mục nhập vào rỗng.");
                        } else {
                          //Add new category
                          widget.onSave(widget.id, ctlInputCategoryName.text);
                          setState(() {});
                          Navigator.of(context).pop();
                        }
                      },
                      child:
                          Text("Xong", style: TextStyle(color: primaryColor)))
                ],
              )))
        ],
      ),
    );
  }
}
