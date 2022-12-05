import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../../../contants.dart';
final List<String> list = [
  "Sự cố - Thoát hiểm", 
  "Bệnh viện",
  "Cảnh sát",
];
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.all(24),
        child: ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
                  height: 16,
                ),
      itemCount: list.length,
      itemBuilder: (context, index) => Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: op20BlackColor,
          )
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          // alignment: WrapAlignment.spaceBetween,
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            Text(list[index], 
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 14)
              ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_outlined,
            color: op40BlackColor,
            size: 15)
          ],
        ),
      ),
    ));
  }


}
