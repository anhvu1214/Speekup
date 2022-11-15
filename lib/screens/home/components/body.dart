import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:speekup_v2/screens/emergency/emergency_screen.dart';
import 'package:speekup_v2/screens/home/components/carousel_slider.dart';
import 'package:speekup_v2/screens/common/search_bar.dart';
import 'package:speekup_v2/screens/home/home_screen.dart';
import 'package:speekup_v2/screens/my_list/my_list.dart';
import 'package:speekup_v2/screens/text_to_speed/text_to_speed_screen.dart';

import '../../../contants.dart';

final List<String> imgList = [
  'assets/images/img_1.jpg',
  'assets/images/img_2.jpg',
  'assets/images/img_3.jpg',
  'assets/images/img_4.jpg',
];
final List<Map<String, dynamic>> btnLabel = [
  {
    "icon": Icon(Icons.mic_none_outlined, color: primaryColor),
    "text": "Phát văn bản",
    "screen": TextToSpeedScreen()
  },
  {
    "icon": Icon(Icons.star_border_rounded, color: primaryColor),
    "text": "Câu của bạn",
    "screen": MyListScreen()
  },
  {
    "icon": Icon(Icons.warning_amber_outlined, color: primaryColor),
    "text": "Bộ câu khẩn cấp",
    "screen": EmergencyScreen()
  },
  {
    "icon": Icon(Icons.settings_outlined, color: primaryColor),
    "text": "Cài đặt",
    "screen": TextToSpeedScreen()
  }
];

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      //Search bar
      Padding(
        padding: EdgeInsets.all(24),
        child: SearchBar()),

      //Welcome text
      Align(
          alignment: Alignment.centerLeft,
          widthFactor: 1.45,
          child: Text("Chào Duyên Ngô,",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32))),
      SizedBox(height: 24),
      //Carousel slidere
      CarouselWithDotsPage(imgList: imgList),
      SizedBox(
        height: 40,
      ),
      //Redirect buttons
      Expanded(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 16,
                ),
                shrinkWrap: true,
                itemCount: btnLabel.length,
                itemBuilder: ((context, index) => buildButtons(
                    context,
                    btnLabel[index]["icon"],
                    btnLabel[index]["text"],
                    btnLabel[index]["screen"])),
              ))),
      //Sign out button
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: OutlinedButton(
              onPressed: () {},
              child: Text("Đăng xuất"),
              style: OutlinedButton.styleFrom(
                primary: primaryColor,
                side: BorderSide(color: primaryColor),
                minimumSize: Size.fromHeight(40),
                textStyle: TextStyle(fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              )))
    ]);
  }
  //Render redirect button
  InkWell buildButtons(BuildContext context, Icon icon, String text,
      StatelessWidget nextScreen) {
    return InkWell(
        onTap: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => nextScreen));
        },
        child: Container(
            width: 312,
            height: 48,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: lightBlackColor)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  icon,
                  SizedBox(width: 20),
                  Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )));
  }
}
