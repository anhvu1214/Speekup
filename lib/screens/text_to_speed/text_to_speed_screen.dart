import 'package:flutter/material.dart';
import 'package:speekup_v2/contants.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speekup_v2/db/sentence_table.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/screens/common/textfield_dialog.dart';
import 'package:speekup_v2/screens/common/utils.dart';

import '../common/bottom_sheet.dart';
import 'components/body.dart';

class TextToSpeedScreen extends StatefulWidget {
  @override
  _TextToSpeedScreen createState() => _TextToSpeedScreen();
}

class _TextToSpeedScreen extends State<TextToSpeedScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final ctlInputText = TextEditingController();

  Future speak(String text) async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          //Text Area
          Container(
            height: 200,
            margin: EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: op20BlackColor)),
            child: TextField(
              controller: ctlInputText,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  hintText: "Gõ văn bản cần phát ở đây.",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16)),
            ),
          ),
          //Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Save button
              OutlinedButton(
                onPressed: () async {
                  // buildBottomSheet(context, listCategory, selectedItems);
                  if (ctlInputText.text == '') {
                    showToast("Cần nhập văn bản.");
                    return;
                  }
                  final isExist =
                      await SentenceTable().isExist(ctlInputText.text);
                  if (isExist != null && !isExist) {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              topLeft: Radius.circular(16)),
                        ),
                        context: context,
                        builder: (context) {
                          return CategoryBottomSheet(
                              context: context, sentence: ctlInputText.text);
                        });
                  } else {
                    showToast("Câu đã tồn tại!");
                  }
                  // buildSelectCategorySheet(context, listCategory, selectedItems);
                },
                child: Text(
                  "Lưu câu",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(148, 40),
                    primary: primaryColor,
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
              OutlinedButton(
                onPressed: () async {
                  speak(ctlInputText.text);
                },
                child: Text(
                  "Phát văn bản",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(148, 40),
                    primary: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: buildFloatingButton(),
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
    );
  }

  Widget buildFloatingButton() {
    return FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => Center(
                      child: TextFieldDialog(
                    title: "Chuyển đổi giọng nói",
                    initText: "",
                    hintText: "Văn bản được chuyển đổi sẽ hiển\n thị tại đây.",
                    subtitle: "Nói để chuyển đổi",
                    inputHeight: 100,
                    id: 0,
                    onSave: () {},
                  )));
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.mic_none_rounded, color: Colors.white));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: lightGrayColor,
      elevation: 0,
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
        "Chuyển đổi văn bản - giọng nói",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
