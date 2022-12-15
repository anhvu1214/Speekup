import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg) => Fluttertoast.showToast(
  msg: msg,
  gravity: ToastGravity.TOP
);

bool isValidEmail(String inputEmail) {
  final emailReg = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  if (!emailReg.hasMatch(inputEmail as String)) {
    return false;
  }
  return true;
}