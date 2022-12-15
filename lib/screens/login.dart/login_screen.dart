import 'package:flutter/material.dart';
import 'package:speekup_v2/db/database_helper.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:speekup_v2/db/user_table.dart';
import 'package:speekup_v2/screens/common/utils.dart';
import 'package:speekup_v2/screens/home/home_screen.dart';
import 'package:speekup_v2/screens/forgot_password/forgot_password_screen.dart';
import 'package:speekup_v2/screens/login.dart/sign_up_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../contants.dart';
import '../common/text_form_field.dart';
import 'components/body.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final login_form_key = new GlobalKey<FormState>();

  var db;
  late UserTable? userData = UserTable();
  // final ;

  final ctlUserID = TextEditingController();
  final ctlPwd = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future setLoggedState() async {
    final SharedPreferences sp = await _prefs;
    sp.setBool('logged', true);
    sp.setString('username', ctlUserID.text);
  }

  login() async {
    final form = login_form_key.currentState;
    // final user_table = UserTable();
    if (form!.validate()) {
      final user = await userData?.authenticateUser(ctlUserID.text, ctlPwd.text);
      // await loginUser.getLoginUser(ctlUserID.text, ctlPwd.text).then((userData) => {
      if (user != null) {
        setLoggedState();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        showToast("Mật khẩu hoặc tên đăng nhập\n không chính xác.");
      }
      // });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Form(
          key: login_form_key,
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
                  Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()));
                          },
                          child: Text(
                            "Quên mật khẩu",
                            style: TextStyle(color: primaryColor),
                          ))),
                  SizedBox(
                    height: 25,
                  ),
                  //Login button
                  OutlinedButton(
                    onPressed: () {
                      login();
                    },
                    child: Text(
                      "Đăng nhập",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                        primary: Colors.white,
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  ),
                  //Sign in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bạn chưa có tài khoản?",
                        style: TextStyle(fontSize: 12, fontWeight: w400Font),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          },
                          child: Text("Đăng ký tại đây",
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
