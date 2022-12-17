import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/db/category_table.dart';
import 'package:speekup_v2/db/sentence_table.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/model/sentence.dart';
import 'package:speekup_v2/screens/common/confirm_dialog.dart';
import 'package:speekup_v2/screens/common/search_bar.dart';
import 'package:speekup_v2/screens/common/textfield_dialog.dart';
import 'package:speekup_v2/screens/home/home_screen.dart';
import 'package:speekup_v2/screens/my_list/components/helper.dart';
import 'package:speekup_v2/screens/sentence_detail.dart/sentence_detail_screen.dart';

import '../../contants.dart';
// import 'components/body.dart';

class MyListScreen extends StatefulWidget {
  MyListScreen(
      {super.key,
      required this.title,
      required this.list,
      this.category,
      this.isDeletable = true});

  final String title;
  // final int id;
  bool isDeletable;
  CategoryModel? category;
  List<dynamic> list;

  @override
  _MyListScreen createState() => _MyListScreen();
}

class _MyListScreen extends State<MyListScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CategoryTable categoryTable = CategoryTable();
  // late List<CategoryModel> listCategories;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isCategory = false;
  bool isSelectionMode = false;
  bool isSelectAll = false;

  List<dynamic> selectedItems = [];

  var listSentences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() => isCategory = widget.list is List<CategoryModel>);
    // getAllCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getAllSentences(int categoryID) async {
    setState(() => isLoading = true);
    listSentences = await SentenceTable().getAllSentencesByCategory(categoryID);
    setState(() => isLoading = false);
  }

  onTapItem(BuildContext context, dynamic item) {
    if (isSelectionMode) {
      selectedItems.contains(item)
          ? selectedItems.remove(item)
          : selectedItems.add(item);
      setState(() {});
    } else {
      selectItem(context, item);
    }
  }

  void selectItem(BuildContext context, dynamic item) async {
    if (isCategory) {
      await getAllSentences(item.id);
      Navigator.push(
          _scaffoldKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => MyListScreen(
                  title: item.name,
                  list: listSentences,
                  category: item))).then((value) async {
        //update list after list sentence screen pop
        setState(() => isLoading = true);
        final SharedPreferences sp = await _prefs;
        widget.list = await CategoryTable()
            .getAllCategoriesByUser(sp.getString('username') as String);
        setState(() => isLoading = false);
      });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SentenceDetailScreen(
                  title: widget.title, sentence: item))).then((value) async {
        setState(() => isLoading = true);
        widget.list = await SentenceTable()
            .getAllSentencesByCategory(widget.category!.id!);
        setState(() => isLoading = false);
      });
    }
  }

  Widget buildAppBar(BuildContext context, String title) {
    return Padding(
        padding: EdgeInsets.only(
            left: 10, top: 15, bottom: 15, right: isSelectionMode ? 25 : 0),
        child: Container(
          child: Row(
            children: [
              isSelectionMode
                  ? IconButton(
                      onPressed: () {
                        //Remove selected items
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => Center(
                                  child: isCategory
                                      ? ConfirmDialog(
                                          title: 'Xóa bộ câu',
                                          confirmContent:
                                              'Bạn có chắc chắn xóa những bộ câu đã được chọn không?',
                                          onConfirm: () {
                                            removeSelectedCategories(
                                                widget.list.cast(),
                                                selectedItems.cast());
                                          })
                                      : ConfirmDialog(
                                          title: 'Xóa câu',
                                          confirmContent:
                                              'Bạn có chắc chắn xóa những câu đã được chọn không?',
                                          onConfirm: () {
                                            removeSelectedSentences(
                                                widget.list.cast(),
                                                selectedItems.cast(),
                                                widget.category!.id!);
                                          }),
                                )).then((value) => setState(() {}));
                      },
                      icon: Icon(
                        Icons.delete_outlined,
                        color: primaryColor,
                      ))
                  : IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: primaryColor,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
              // SizedBox(width: 95),
              Spacer(),
              Text(
                widget.title,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
              // isSelectionMode ? SizedBox(width: 75) : SizedBox(width: 120),
              Spacer(),
              widget.isDeletable
                  ? isSelectionMode
                      ? Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                              OutlinedButton(
                                  onPressed: () {
                                    selectedItems = [];
                                    setState(() => isSelectionMode = false);
                                  },
                                  style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(33, 18),
                                      backgroundColor: Color(0x33AD552F),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      side: BorderSide.none),
                                  child: Text(
                                    "Hủy",
                                    style: TextStyle(
                                        color: primaryColor, fontSize: 12),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  selectedItems.clear();
                                  selectedItems.addAll(widget.list);
                                  if (isCategory) {selectedItems.removeWhere((element) => element.name == 'Đã lưu');} 
                                  setState(() => isSelectAll = !isSelectAll);
                                },
                                child: isSelectAll
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: primaryColor,
                                      )
                                    : Icon(Icons.circle_outlined,
                                        color: op20BlackColor),
                              ),
                            ])
                      : Align(
                          alignment: Alignment.centerRight,
                          child: PopupMenuButton<int>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            position: PopupMenuPosition.under,
                            itemBuilder: (context) => [
                              //Add new category
                              PopupMenuItem(
                                  child: Text("Tạo mới"),
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(seconds: 0),
                                        () => {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) => Center(
                                                      //Test: Lần đầu chạy list có tự cập nhật không?
                                                      child: isCategory
                                                          ? TextFieldDialog(
                                                              title:
                                                                  "Tạo bộ câu mới",
                                                              initText: "",
                                                              id: 0,
                                                              onSave: (id,
                                                                  newValue) async {
                                                                CategoryModel
                                                                    newCat =
                                                                    await addNewCategory(
                                                                        _prefs,
                                                                        newValue);
                                                                setState(() {
                                                                  widget.list.add(
                                                                      newCat);
                                                                });
                                                              },
                                                            )
                                                          : TextFieldDialog(
                                                              title:
                                                                  "Tạo câu mới",
                                                              initText: "",
                                                              onSave: (id,
                                                                  newValue) async {
                                                                SentenceModel
                                                                    newSen =
                                                                    await addNewSentence(
                                                                        newValue,
                                                                        widget
                                                                            .category!
                                                                            .id!);
                                                                setState(() {
                                                                  widget.list.add(
                                                                      newSen);
                                                                });
                                                              },
                                                              id: 0))).then(
                                                  (value) {
                                                setState(() {});
                                              })
                                            });
                                  }),
                              PopupMenuDivider(),
                              PopupMenuItem(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => isSelectionMode = true);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Chọn"),
                                ),
                              )
                            ],
                            child: Padding(
                                padding: EdgeInsets.only(right: 24),
                                child: Icon(Icons.more_horiz_outlined,
                                    color: primaryColor)),
                          ),
                        )
                  : Container(),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
            child: Column(
          children: [
            buildAppBar(context, widget.title),
            Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: SearchBar()),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(24),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 16,
                          ),
                          itemCount: widget.list.length,
                          itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                onTapItem(context, widget.list[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: op20BlackColor,
                                    )),
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  // alignment: WrapAlignment.spaceBetween,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            isCategory
                                                ? widget.list[index].name
                                                : widget.list[index].word,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    widget.isDeletable
                                        ? isCategory
                                            ? (widget.list[index].isDeletable ==
                                                    1
                                                ? (switchMode(
                                                    widget.list
                                                        .cast<CategoryModel>(),
                                                    widget.list[index]))
                                                : (SizedBox(
                                                    height: 25,
                                                  )))
                                            : (switchMode(
                                                widget.list
                                                    .cast<SentenceModel>(),
                                                widget.list[index]))
                                        : Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: op40BlackColor,
                                            size: 15,
                                          )
                                  ],
                                ),
                              )),
                        )))
          ],
        )));
  }

  Widget switchMode(List<dynamic> list, dynamic item) {
    return isSelectionMode
        ? (selectedItems.contains(item)
            ? Icon(Icons.check_circle_rounded, color: primaryColor)
            : Icon(Icons.circle_outlined, color: op20BlackColor))
        : (widget.category == null
            ? buildPopMenu(list, item, setState, 0)
            : buildPopMenu(list, item, setState, widget.category!.id!));
  }
}
