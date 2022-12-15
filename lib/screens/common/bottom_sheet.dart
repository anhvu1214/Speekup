import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/db/category_table.dart';
import 'package:speekup_v2/db/sentence_table.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/model/sentence.dart';
import 'package:speekup_v2/screens/common/textfield_dialog.dart';
import 'package:speekup_v2/screens/common/utils.dart';
import 'package:speekup_v2/screens/my_list/components/helper.dart';

import '../../contants.dart';

class CategoryBottomSheet extends StatefulWidget {
  CategoryBottomSheet({
    super.key,
    required this.context,
    required this.sentence,
  });

  final BuildContext context;
  final String sentence;

  @override
  _CategoryBottomSheet createState() => _CategoryBottomSheet();
}

class _CategoryBottomSheet extends State<CategoryBottomSheet> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> tempSelectedItems = [];
  List<String> selectedItems = [];
  late List<CategoryModel> list;
  late List<CategoryModel> listCategoriesOfSentence;
  late SentenceTable? sentenceTable;
  late SentenceModel sentence;

  bool isLoading = false;
  bool isSentenceExist = false;

  @override
  void initState() {
    super.initState();
    sentenceTable = SentenceTable();
    getSentence();
    getCategoriesList();
  }

  //Init sentence + list categories of sentence
  void getSentence() async {
    var isExist = await SentenceTable().isExist(widget.sentence);
    setState(() => isSentenceExist = isExist);
    if (isSentenceExist) {
      setState(() => isLoading = true);
      sentence = await sentenceTable!.getSentence(widget.sentence);
      selectedItems =
          await CategoryTable().getAllCategoriesBySentence(sentence.id as int);
      tempSelectedItems.addAll(selectedItems);
      setState(() => isLoading = false);
    } else {
      selectedItems = [];
    }
  }

  //Get all categories of user
  void getCategoriesList() async {
    setState(() => isLoading = true);
    final SharedPreferences sp = await _prefs;
    list =
        await CategoryTable().getAllCategoriesByUser(sp.getString('username')!);
    setState(() => isLoading = false);
  }

  void saveSentence() async {
    if (!isSentenceExist) {
      sentence = await sentenceTable
          ?.create(SentenceModel(word: widget.sentence)) as SentenceModel;
    } else {
      sentence = await sentenceTable!.getSentence(widget.sentence);
    }

    //Add sentence to category
    try {
      list.forEach((element) async {
        //  selectedItems.contains(element.name) ? ;
        if (tempSelectedItems.contains(element.name) &&
            !selectedItems.contains(element.name)) {
          await sentenceTable?.addToCategory(sentence, element.id as int);
        }
        ;
        if (!tempSelectedItems.contains(element.name) &&
            selectedItems.contains(element.name)) {
          await sentenceTable?.removeFromCategory(sentence, element.id as int);
        }
      });
      showToast("Lưu thành công.");
    } catch (e) {
      showToast("Lưu không thành công");
    }
    selectedItems.addAll(tempSelectedItems);

    setState(() {});
  }

  //   addNewCategory(String newValue) async {
  //   SharedPreferences sp = await _prefs;
  //   CategoryModel cat = await CategoryTable().create(CategoryModel(name: newValue, username: sp.getString('username')!));

  //   setState((){});
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 315,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              SizedBox(
                  // height: 51,
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Hủy",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: w500Font,
                            fontSize: 14),
                      )),
                  Text(
                    "Chọn bộ câu",
                    style: TextStyle(fontWeight: w600Font, fontSize: 16),
                  ),
                  TextButton(
                      onPressed: () {
                        saveSentence();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Xong",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: w500Font,
                            fontSize: 14),
                      )),
                ],
              )),
              Divider(
                thickness: 1,
                height: 3,
              ),
              SizedBox(
                  height: 44,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => Center(
                                //     child: CategoryDialog(
                                //   list: list,
                                //   selectedItems: tempSelectedItems,
                                // )
                                child: TextFieldDialog(
                                  id: 0,
                                  title: "Tạo bộ câu mới",
                                  initText: "",
                                  onSave: (id, newValue) async {
                                    CategoryModel cat =
                                        await addNewCategory(_prefs, newValue);
                                    list.add(cat);
                                    tempSelectedItems.add(newValue);
                                  },
                                ),
                              )).then((value) => setState(
                            () {},
                          ));
                    },
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.add_circle_outline_rounded,
                              color: primaryColor,
                              size: 18,
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            Text(
                              "Tạo mới",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: w400Font,
                                  fontSize: 14),
                            )
                          ],
                        )),
                  )),
              Divider(
                thickness: 1,
                height: 3,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 2,
                              thickness: 1,
                            );
                          },
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                key: UniqueKey(),
                                onTap: () {
                                  tempSelectedItems.contains(list[index].name)
                                      ? (tempSelectedItems.length == 1 ? tempSelectedItems : tempSelectedItems
                                          .remove(list[index].name))
                                      : tempSelectedItems.add(list[index].name);
                                  setState(() {});
                                  // tempSelectedItems.contains(list[index].name);
                                },
                                child: SizedBox(
                                    height: 44,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 13,
                                            top: 14,
                                            bottom: 14),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              list[index].name,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Visibility(
                                                visible: tempSelectedItems
                                                    .contains(list[index].name),
                                                child: Icon(Icons.check_rounded,
                                                    color: primaryColor))
                                          ],
                                        ))));
                          }))
            ],
          )),
    );
  }
}
