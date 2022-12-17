import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/db/category_table.dart';
import 'package:speekup_v2/db/sentence_table.dart';
import 'package:speekup_v2/db/user_table.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/model/sentence.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:speekup_v2/screens/common/utils.dart';
import 'package:speekup_v2/screens/login.dart/login_screen.dart';
import 'package:speekup_v2/screens/splash_screen.dart';

import '../../contants.dart';
import '../common/text_form_field.dart';
import '../home/home_screen.dart';
import 'components/body.dart';

List<String> suco = ['Cứu tôi với', 'Có cháy', 'Cướp'];

List<String> bv = [
  'Chỗ mua thuốc ở đâu',
  'Còn bao lâu thì đến lượt tôi khám',
  'Tôi có dùng thẻ bảo hiểm này được không'
];

List<String> cs = ['Cửa hàng này buôn bán thực phẩm kém chất lượng'];

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late UserTable? user = UserTable();
  late CategoryTable? categoryTable = CategoryTable();
  late SentenceTable? sentenceTable = SentenceTable();
  final signup_form_key = new GlobalKey<FormState>();

  final ctlEmail = TextEditingController();
  final ctlFullname = TextEditingController();
  final ctlUserID = TextEditingController();
  final ctlPwd = TextEditingController();
  final ctlConfPwd = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  signup() async {
    final form = signup_form_key.currentState;
    final SharedPreferences sp = await _prefs;

    String uid = ctlUserID.text;
    String uname = ctlFullname.text;
    String email = ctlEmail.text;
    String passwd = ctlPwd.text;
    String cpasswd = ctlConfPwd.text;

    if (form!.validate()) {
      final isExist = await user?.isValidUsername(ctlUserID.text);
      if (isExist != null && !isExist) {
        if (passwd != cpasswd) {
          // Alert confirm password is incorrect
          showToast("Mật khẩu xác thực không chính xác.");
        } else {
          form.save();
          sp.setString('username', uid);
          sp.setBool('logged', true);
          UserModel uModel = UserModel(
              username: uid, fullname: uname, email: email, password: passwd);
          try {
            await user?.create(uModel);
            createDefault(uid);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SplashScreen()));
          } catch (e) {
            // alertDialog(context, "Error: Data Save Fail");
            showToast("Đã có lỗi xảy ra!");
          }
        }
      } else {
        //Alert username is already exist
        showToast("Tên đăng nhập đã tồn tại!");
      }
    }
  }

  createDefault(String uid) async {
    await categoryTable
        ?.create(CategoryModel(name: 'Đã lưu', username: uid, isDeletable: 0));
    CategoryModel c1 = await categoryTable?.create(CategoryModel(
        name: 'Sự cố - Thoát hiểm',
        username: uid,
        isDeletable: 0)) as CategoryModel;
    CategoryModel c2 = await categoryTable?.create(
            CategoryModel(name: 'Bệnh viện', username: uid, isDeletable: 0))
        as CategoryModel;
    CategoryModel c3 = await categoryTable?.create(
            CategoryModel(name: 'Cảnh sát', username: uid, isDeletable: 0))
        as CategoryModel;
    suco.forEach((element) async {
      SentenceModel s1 = await sentenceTable?.create(
          SentenceModel(word: element, isDeletable: 0)) as SentenceModel;
      sentenceTable?.addToCategory(s1, c1.id as int);
    });
    bv.forEach((element) async {
      SentenceModel s1 = await sentenceTable?.create(
          SentenceModel(word: element, isDeletable: 0)) as SentenceModel;
      sentenceTable?.addToCategory(s1, c2.id as int);
    });
    cs.forEach((element) async {
      SentenceModel s1 = await sentenceTable?.create(
          SentenceModel(word: element, isDeletable: 0)) as SentenceModel;
      sentenceTable?.addToCategory(s1, c3.id as int);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
          key: signup_form_key,
          child: Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
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
                    controller: ctlFullname,
                    hintText: "Tên người dùng",
                    isHide: false,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  BuildTextFormField(
                    controller: ctlUserID,
                    hintText: "Tên đăng nhập",
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text("Đăng nhập",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontWeight: w400Font)))
                    ],
                  )
                ],
              ))))),
    );
  }
}
