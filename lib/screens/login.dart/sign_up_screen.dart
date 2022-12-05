import 'package:flutter/material.dart';
import 'package:speekup_v2/screens/login.dart/login_screen.dart';

import '../../contants.dart';
import '../common/text_form_field.dart';
import '../home/home_screen.dart';
import 'components/body.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final signup_form_key = new GlobalKey<FormState>();

  final ctlEmail = TextEditingController();
  final ctlUserID = TextEditingController();
  final ctlPwd = TextEditingController();
  final ctlConfPwd = TextEditingController();

  signup() {
    final form = signup_form_key.currentState;
    if (form!.validate()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        key: signup_form_key,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // Text "Speekup"
              Padding(
                  padding: EdgeInsets.only(top: 160, bottom: 80),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "SKEEKUP",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 50,
                        ),
                      ))),
              //Form
              BuildTextFormField(
                controller: ctlEmail,
                hintText: "Email",
                inputType: TextInputType.emailAddress,
                isHide: false,
              ),
              SizedBox(
                height: 24,
              ),
              BuildTextFormField(
                controller: ctlUserID,
                hintText: "Tên người dùng",
                isHide: false,
              ),
              SizedBox(
                height: 24,
              ),
              BuildTextFormField(
                controller: ctlPwd,
                hintText: "Mật khẩu",
                isHide: true,
              ),
              SizedBox(
                height: 24,
              ),
              BuildTextFormField(
                controller: ctlConfPwd,
                hintText: "Nhập lại mmật khẩu",
                isHide: true,
              ),
              SizedBox(
                height: 24,
              ),
              //Login button
              OutlinedButton(
                onPressed: () {
                  signup();
                },
                child: Text(
                  "Đăng ký",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                    primary: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bạn đã có tài khoản?",
                    style: TextStyle(fontSize: 12, fontWeight: w400Font),
                  ),
                  TextButton(
                      onPressed: () {
                        
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text("Đăng nhập",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: w400Font)))
                ],
              )
            ],
          ))),
    );
  }
}
