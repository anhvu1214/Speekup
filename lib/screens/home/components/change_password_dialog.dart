import 'package:flutter/material.dart';
import 'package:speekup_v2/contants.dart';
import 'package:speekup_v2/db/user_table.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:speekup_v2/screens/common/utils.dart';

import '../../common/text_form_field.dart';
import 'input_field.dart';

TextEditingController oldPwd = TextEditingController();
TextEditingController newPwd = TextEditingController();
TextEditingController cnewPwd = TextEditingController();
void showChangePwdDialog(BuildContext context, UserModel user) {
  showDialog(
      context: context,
      builder: (context) => Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              insetPadding: EdgeInsets.all(70),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16),
                      child: Text("Đổi mật khẩu",
                          style:
                              TextStyle(fontWeight: w600Font, fontSize: 16))),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Wrap(
                        spacing: 15,
                        children: <Widget>[
                          BuildTextFormField(
                              controller: oldPwd,
                              hintText: "Mật khẩu cũ",
                              isHide: true,
                              fillColor: Colors.white),
                          SizedBox(height: 15),
                          BuildTextFormField(
                              controller: newPwd,
                              hintText: "Mật khẩu mới",
                              isHide: true,
                              fillColor: Colors.white),
                          SizedBox(height: 15),
                          BuildTextFormField(
                              controller: cnewPwd,
                              hintText: "Nhập lại mật khẩu mới",
                              isHide: true,
                              fillColor: Colors.white)
                        ],
                      )),
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
                              child: Text("Hủy",
                                  style: TextStyle(color: Colors.black))),
                          VerticalDivider(thickness: 1, width: 1),
                          TextButton(
                              onPressed: () async {
                                if (user.password == oldPwd.text) {

                                  if(newPwd.text == cnewPwd.text) {
                                    user.password = newPwd.text;
                                    await UserTable().update(user);
                                    Navigator.pop(context);
                                  } else {
                                    //Alert
                                    showToast("Mật khẩu nhập lại không chính xác.");
                                  }
                                } else {
                                  //Alert
                                  showToast("Mật khẩu cũ không chính xác.");
                                }
                              },
                              child: Text("Xác nhận",
                                  style: TextStyle(color: primaryColor)))
                        ],
                      )))
                ],
              ),
            ),
          ));
}
