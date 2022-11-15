import 'package:flutter/material.dart';
import 'package:speekup_v2/contants.dart';

import 'components/body.dart';

class TextToSpeedScreen extends StatelessWidget {
  const TextToSpeedScreen({Key? key}) : super(key: key);

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
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          color: primaryColor,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      leadingWidth: 90,
      centerTitle: true,
      title: Text(
        "Phát văn bản",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
