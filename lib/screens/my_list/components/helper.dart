import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/db/category_table.dart';
import 'package:speekup_v2/db/sentence_table.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/model/sentence.dart';
import 'package:speekup_v2/screens/common/confirm_dialog.dart';
import 'package:speekup_v2/screens/common/textfield_dialog.dart';

import '../../../contants.dart';

void removeSelectedCategories(
    List<CategoryModel> list, List<CategoryModel> selectedItems) {
  List<dynamic> temp = [];
  list.forEach((element) {
    if (selectedItems.contains(element)) {
      //Remove element from list and selectedItem
      CategoryTable().delete(element.id as int);
    } else {
      temp.add(element);
    }
  });
  list.clear();
  list.addAll(temp.cast<CategoryModel>());
  selectedItems.clear();
}

void removeSelectedSentences(
    List<SentenceModel> list, List<SentenceModel> selectedItems, int id) {
  List<dynamic> temp = [];
  list.forEach((element) {
    if (selectedItems.contains(element)) {
      //Remove element from list and selectedItem
      SentenceTable().removeFromCategory(element, id);
    } else {
      temp.add(element);
    }
  });
  list.clear();
  list.addAll(temp.cast<SentenceModel>());
  selectedItems.clear();
}

updateCategory(CategoryModel category, String newValue) async {
  category.name = newValue;
  int cat = await CategoryTable().update(category);
}

updateSentence(SentenceModel sentence, String newValue) async {
  sentence.word = newValue;
  await SentenceTable().update(sentence);
}

Future<CategoryModel> addNewCategory(
    Future<SharedPreferences> _prefs, String newCategory) async {
  SharedPreferences sp = await _prefs;
  CategoryModel cat = await CategoryTable().create(
      CategoryModel(name: newCategory, username: sp.getString('username')!));
  return cat;
}

Future<SentenceModel> addNewSentence(String newSentence, int categoryID) async {
  final SentenceTable sentenceTable = SentenceTable();
  SentenceModel sen =
      await sentenceTable.create(SentenceModel(word: newSentence));

  sentenceTable.addToCategory(sen, categoryID);
  return sen;
}

Widget buildPopMenu(
    List<dynamic> list, dynamic item, StateSetter setState, int id) {
  bool isCategory = item is CategoryModel;
  return PopupMenuButton<int>(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    position: PopupMenuPosition.under,
    itemBuilder: (context) => [
      PopupMenuItem(
          child: isCategory ? Text("Đổi tên") : Text("Sửa câu"),
          onTap: () {
            Future.delayed(
                const Duration(seconds: 0),
                (() => {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => Center(
                                child: isCategory
                                    ? TextFieldDialog(
                                        title: "Đổi tên",
                                        initText: item.name,
                                        id: item.id as int,
                                        onSave: (id, newValue) {
                                          updateCategory(item, newValue);
                                        },
                                      )
                                    : TextFieldDialog(
                                        title: "Sửa câu",
                                        initText: item.word,
                                        id: item.id as int,
                                        onSave: (id, newValue) {
                                          updateSentence(item, newValue);
                                        },
                                      ),
                              )).then((value) => setState(() {}))
                    }));
          }),
      PopupMenuDivider(),
      PopupMenuItem(
          child: Text("Xóa"),
          onTap: () {
            //TODO: Show confirm dialog
            Future.delayed(
                const Duration(seconds: 0),
                () => {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => Center(
                              child: isCategory
                                  ? ConfirmDialog(
                                      title: "Xóa bộ câu",
                                      confirmContent:
                                          "Bạn có chắc chắc muốn xóa bộ câu ${item.name} không?",
                                      onConfirm: () {
                                        removeSelectedCategories(
                                            list.cast(), [item]);
                                      },
                                    )
                                  : ConfirmDialog(
                                      title: "Xóa câu",
                                      confirmContent:
                                          "Bạn có chắc chắc muốn xóa câu này khỏi bộ câu không?",
                                      onConfirm: () {
                                        removeSelectedSentences(
                                            list.cast(), [item], id);
                                      },
                                    ))).then((value) => setState(() {}))
                    });
          })
    ],
    child: Icon(Icons.more_horiz, color: primaryColor),
  );
}
