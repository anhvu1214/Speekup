// import 'package:flutter/cupertino.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// import 'package:flutter/material.dart';
// import 'package:speekup_v2/model/category.dart';

// import '../../../contants.dart';
// import '../../common/bottom_sheet.dart';
// class Body extends StatefulWidget {
//   Body({super.key, required this.context, this.listCategory});

//   final BuildContext context;
//   final List<CategoryModel>? listCategory;
//   @override
//   _Body createState() => _Body();
// }

// class _Body extends State<Body> {
  
//   final FlutterTts flutterTts = FlutterTts();
//   final ctlInputText = TextEditingController();

//   Future speak(String text) async {
//     // print(await flutterTts.isLanguageInstalled("en-AU"));
//     await flutterTts.setLanguage("vi-VN");
//     await flutterTts.speak(text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         //Text Area
//         Container(
//           height: 200,
//           margin: EdgeInsets.all(24),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: op20BlackColor)),
//           child: TextField(
//             controller: ctlInputText,
//             maxLines: null,
//             keyboardType: TextInputType.multiline,
//             decoration: InputDecoration(
//                 hintText: "Gõ văn bản cần phát ở đây.",
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.all(16)),
//           ),
//         ),
//         //Buttons
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             //Save button
//             OutlinedButton(
//               onPressed: () {
//                 buildBottomSheet(context, widget.listCategory ?? []);
//               },
//               child: Text(
//                 "Lưu câu",
//                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//               ),
//               style: OutlinedButton.styleFrom(
//                   minimumSize: Size(148, 40),
//                   primary: primaryColor,
//                   side: BorderSide(color: primaryColor),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   )),
//             ),
//             OutlinedButton(
//               onPressed: () async {
//                 speak(ctlInputText.text);
//               },
//               child: Text(
//                 "Phát văn bản",
//                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//               ),
//               style: OutlinedButton.styleFrom(
//                   minimumSize: Size(148, 40),
//                   primary: Colors.white,
//                   backgroundColor: primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   )),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
