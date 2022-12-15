import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../contants.dart';

class OtpForm extends StatelessWidget {
  TextEditingController ctl1digit = TextEditingController();
  TextEditingController ctl2digit = TextEditingController();
  TextEditingController ctl3digit = TextEditingController();
  TextEditingController ctl4digit = TextEditingController();


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
                        "Nhập mã xác nhận",
                        style: TextStyle(
                          color: op80BlackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ))),
              //Form
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildDigitInput(context, ctl1digit),
                    buildDigitInput(context, ctl2digit),
                    buildDigitInput(context, ctl3digit),
                    buildDigitInput(context, ctl4digit)
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              //Login button
              OutlinedButton(
                onPressed: () {
                  String otp = ctl1digit.text + ctl2digit.text + ctl3digit.text + ctl4digit.text;
                },
                child: Text(
                  "Tiếp tục",
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

  Widget buildDigitInput(BuildContext context, TextEditingController ctl) {
    return Container(
      height: 64,
      width: 48,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: op20BlackColor,
          )),
      child: TextFormField(
        controller: ctl,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "0",
            hintStyle: TextStyle(color: op80BlackColor)),
        style: TextStyle(
            color: op80BlackColor, fontWeight: w400Font, fontSize: 32),
      ),
    );
  }
}
