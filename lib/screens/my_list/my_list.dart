import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../../contants.dart';
import 'components/body.dart';
class MyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: false,
      body: Body(),
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 6,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: primaryColor,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      leadingWidth: 85,
      centerTitle: true,
      title: Text(
        "Câu của bạn",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
      ),
       actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.more_horiz_outlined, color: primaryColor),
              onPressed: () {})
        ]
    );
  }
  
}