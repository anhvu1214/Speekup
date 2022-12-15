import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speekup_v2/contants.dart';
import 'package:speekup_v2/db/user_table.dart';
import 'package:speekup_v2/model/user.dart';

import '../../common/text_form_field.dart';
import '../../common/utils.dart';
import 'input_field.dart';

TextEditingController ctlFullname = TextEditingController();
TextEditingController ctlUsername = TextEditingController();
TextEditingController ctlEmail = TextEditingController();
final edit_form_key = new GlobalKey<FormState>();
double height = 36;

Widget editDialogContent(BuildContext context, UserModel user) {
  ctlFullname.text = user.fullname;
  ctlUsername.text = user.username;
  ctlEmail.text = user.email;
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    insetPadding: EdgeInsets.all(70),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text("Sửa thông tin",
                style: TextStyle(fontWeight: w600Font, fontSize: 16))),
        Form(
          key: edit_form_key,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Wrap(
                // spacing: 15,
                children: <Widget>[
                  Text("Họ và tên",
                      style: TextStyle(
                          color: op60BlackColor,
                          fontSize: 12,
                          fontWeight: w500Font)),
                  SizedBox(height: 20),
                  BuildTextFormField(
                      controller: ctlFullname,
                      hintText: "",
                      fillColor: Colors.white,
                      height: 36,
                      contentPadding: 10),
                  SizedBox(height: 55),
                  Text("Tên đăng nhập",
                      style: TextStyle(
                          color: op60BlackColor,
                          fontSize: 12,
                          fontWeight: w500Font)),
                  SizedBox(height: 20),
                  BuildTextFormField(
                      controller: ctlUsername,
                      hintText: "",
                      fillColor: Colors.white,
                      height: 36,
                      contentPadding: 10),
                  SizedBox(height: 55),
                  Text("Email",
                      style: TextStyle(
                          color: op60BlackColor,
                          fontSize: 12,
                          fontWeight: w500Font)),
                  SizedBox(height: 20),
                  BuildTextFormField(
                      controller: ctlEmail,
                      hintText: "",
                      inputType: TextInputType.emailAddress,
                      fillColor: Colors.white,
                      height: 36,
                      contentPadding: 10)
                ],
              )),
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
                    child: Text("Hủy", style: TextStyle(color: Colors.black))),
                VerticalDivider(thickness: 1, width: 1),
                TextButton(
                    onPressed: () async {
                      confirmEditInfo(context, user);
                    },
                    child:
                        Text("Xác nhận", style: TextStyle(color: primaryColor)))
              ],
            )))
      ],
    ),
  );
}

confirmEditInfo(BuildContext context, UserModel user) async {
  final form = edit_form_key.currentState;
  String fullname = ctlFullname.text;
  String username = ctlUsername.text;
  String email = ctlEmail.text;

  if (fullname == '' || email == '' || username == '') {
    //Alert empty
    showToast("Không được để trống.");
  } else if (!isValidEmail(email)){
    //Alert invalid    
    showToast("Email không hợp lệ.");
  } else {
    user.fullname = ctlFullname.text;
    user.email = ctlEmail.text;
    await UserTable().update(user);
    Navigator.pop(context);
  }
}

