import 'package:flutter/material.dart';

import '../../contants.dart';

class BuildTextFormField extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  TextInputType inputType;
  bool isHide;

  BuildTextFormField({Key? key,required this.controller, required this.hintText, this.inputType = TextInputType.text, this.isHide = false})
      : super(key: key);

  @override
  State<BuildTextFormField> createState() => _BuildTextFormField();
}

class _BuildTextFormField extends State<BuildTextFormField> {
  bool isShow = false;
  @override
  void initState() {
    super.initState();
    isShow = widget.isHide;
  }

  @override
  Widget build(BuildContext context) {
  String hintText = widget.hintText;

    return Container(
      child: TextFormField(
        keyboardType: widget.inputType,
        controller: widget.controller,
        validator: ((value) {
          if (hintText == "Email") {
            final emailReg = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
          if (!emailReg.hasMatch(value as String)) {
            return 'Email không đúng định dạng';
          }
          };
          if (value == null || value.isEmpty) {
            return '$hintText không được bỏ trống.';
          }
        }),
        // onSaved: (value) => widget.controller.text = value as String,
        decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIconColor: op60BlackColor,
            iconColor: primaryColor,
            suffixIcon: widget.isHide
                ? GestureDetector(
                    onTap: () => setState(() {
                          isShow = !isShow;
                          print(isShow);
                        }),
                    child: Icon(isShow
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                        color: op60BlackColor,))
                : null,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: op20BlackColor)),
            contentPadding: EdgeInsets.all(16),
            hintStyle: TextStyle(
                color: op40BlackColor,
                fontWeight: FontWeight.w400,
                fontSize: 14),
            filled: true,
            fillColor: lightGrayColor),
        obscureText: isShow,
      ),
    );
  }
}
