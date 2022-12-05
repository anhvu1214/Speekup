import 'package:flutter/material.dart';

import '../../contants.dart';
import '../common/text_form_field.dart';
import 'components/body.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final ctlUserEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.5,
        toolbarHeight: 48,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: primaryColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 90,
        title: Text("Quên mật khẩu"),
        titleTextStyle:
            TextStyle(color: Colors.black, fontWeight: w700Font, fontSize: 16),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // Text "Speekup"
              Padding(
                  padding: EdgeInsets.only(top: 51, bottom: 80),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Nhập Email của bạn",
                        style: TextStyle(
                          color: op80BlackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ))),
              //Form
              BuildTextFormField(
                controller: ctlUserEmail,
                hintText: "Email",
                isHide: false,
              ),
              SizedBox(
                height: 24,
              ),
              //Login button
              OutlinedButton(
                onPressed: () {},
                child: Text(
                  "Gửi mã xác nhận",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                    primary: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              )
            ],
          )),
    );
  }
}
