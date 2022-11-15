import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speekup_v2/contants.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(),
          resizeToAvoidBottomInset: false,
          body:  Body(),
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 2.5,
        toolbarHeight: 48,
        leading: Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Row(
              children: const <Widget>[
                Icon(Icons.person_outlined, color: Colors.black),
                SizedBox(width: 10),
                Text('duyennt', style: TextStyle(color: Colors.black)),
              ],
            )),
        leadingWidth: 200,
        titleSpacing: 0,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.help_outline, color: primaryColor),
              onPressed: () {})
        ]);
  }
}
