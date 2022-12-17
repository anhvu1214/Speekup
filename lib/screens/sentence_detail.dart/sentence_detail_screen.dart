import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speekup_v2/contants.dart';
import 'package:speekup_v2/db/sentence_table.dart';
import 'package:speekup_v2/model/sentence.dart';
import 'package:speekup_v2/screens/common/bottom_sheet.dart';
import 'package:speekup_v2/screens/common/confirm_dialog.dart';
import 'package:speekup_v2/screens/common/textfield_dialog.dart';
import 'package:speekup_v2/screens/my_list/components/helper.dart';
import 'package:speekup_v2/screens/sentence_detail.dart/icon_button.dart';

class SentenceDetailScreen extends StatefulWidget {
  SentenceDetailScreen(
      {super.key, required this.title, required this.sentence});

  final String title;
  final SentenceModel sentence;

  @override
  _SentenceDetailScreen createState() => _SentenceDetailScreen();
}

class _SentenceDetailScreen extends State<SentenceDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: lightGrayColor,
          elevation: 0,
          leadingWidth: 35,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.only(left: 25),
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: primaryColor, size: 15)),
          title: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(widget.title,
            style: TextStyle(
                color: primaryColor, fontSize: 14, fontWeight: w400Font)),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(widget.sentence.word,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: w400Font,
                            color: Colors.white)),
                  ),
                ),
                SizedBox(height: 22),
                Row(
                  children: [
                    //Remove all button
                    widget.sentence.isDeletable == 1
                        ? Wrap(children: [
                            CustomIconButton(
                                icon: Icon(Icons.delete_outlined),
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => Center(
                                              child: ConfirmDialog(
                                            title: "Xoá câu",
                                            confirmContent:
                                                "Bạn có chắc chắn muốn xóa câu này khỏi tất cả các danh mục không?",
                                            onConfirm: (() {
                                              SentenceTable().delete(
                                                  widget.sentence.id as int);
                                              Navigator.pop(context);
                                            }),
                                          )));
                                }),
                            SizedBox(width: 16),
                            CustomIconButton(
                                icon: Icon(Icons.mode_edit_outline_outlined),
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => Center(
                                            child: TextFieldDialog(
                                              title: "Sửa câu",
                                              initText: widget.sentence.word,
                                              id: widget.sentence.id as int,
                                              onSave: (id, newValue) {
                                                updateSentence(
                                                    widget.sentence, newValue);
                                              },
                                            ),
                                          )).then((value) => setState(() {}));
                                }),
                            SizedBox(width: 16)
                          ])
                        : Container(),
                    CustomIconButton(
                        icon: Icon(Icons.bookmark_outlined),
                        iconColor: lightGrayColor,
                        backgroundColor: primaryColor,
                        borderColor: primaryColor,
                        onPressed: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16)),
                              ),
                              context: context,
                              builder: (context) {
                                return CategoryBottomSheet(
                                    context: context,
                                    sentence: widget.sentence.word);
                              });
                        }),
                    // SizedBox(width: MediaQuery.of(context).size.width - 204),
                    Spacer(),
                    CustomIconButton(
                        icon: Icon(Icons.volume_up_outlined),
                        buttonSize: 40,
                        iconSize: 25,
                        iconColor: lightGrayColor,
                        backgroundColor: primaryColor,
                        borderColor: primaryColor,
                        onPressed: () async {
                          await flutterTts.setLanguage("vi-VN");
                          await flutterTts.speak(widget.sentence.word);
                        }),
                  ],
                ),
                SizedBox(height: 16.5),
                Row(children: [
                  Text("Ghi chú",
                      style: TextStyle(fontSize: 16, fontWeight: w400Font)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => Center(
                                  child: TextFieldDialog(
                                      title: "Ghi chú",
                                      initText:
                                          widget.sentence.description == null
                                              ? ""
                                              : widget.sentence.description
                                                  as String,
                                      id: widget.sentence.id as int,
                                      onSave: (id, newValue) async {
                                        widget.sentence.description = newValue;
                                        await SentenceTable()
                                            .update(widget.sentence);
                                      }),
                                ));
                      },
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.edit_outlined,
                          color: primaryColor, size: 17))
                ]),
                Text(
                    widget.sentence.description == null
                        ? ""
                        : widget.sentence.description as String,
                    style: TextStyle(
                        fontWeight: w400Font,
                        fontSize: 14,
                        color: op80BlackColor))
              ],
            )));
  }
}
