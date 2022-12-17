import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/db/sentence_table.dart';
import 'package:speekup_v2/model/sentence.dart';
import 'package:speekup_v2/screens/my_list/my_list.dart';
import 'package:speekup_v2/screens/sentence_detail.dart/sentence_detail_screen.dart';

import '../../contants.dart';
import '../../db/category_table.dart';
import '../../model/category.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final GlobalKey _autocompleteKey = GlobalKey();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FocusNode _focus = FocusNode();
  TextEditingController _controller = TextEditingController();
  bool _isTapped = false;
  bool isLoading = false;
  List<CategoryModel> listCategories = [];
  List<SentenceModel> listSentences = [];
  List<String> autoCatList = [];
  List<String> autoSenList = [];
  List<String> autoList = [];
  void _handleTap() {
    setState(() {
      _isTapped = !_isTapped;
    });
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    getAllCategories();
    getAllSentences();
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isTapped = !_isTapped;
    });
  }

  void clearList() {
    autoList.clear();
    autoCatList.clear();
    autoSenList.clear();
  }

  getAllSentences() async {
    clearList();
    setState(() => isLoading = true);
    final SharedPreferences sp = await _prefs;
    listSentences = await SentenceTable()
        .getAllSentencesByUser(sp.getString('username') as String);
    listSentences.forEach((element) async {
      var list =
          await CategoryTable().getAllCategoriesBySentence(element.id as int);
      autoList.add("Câu:" + element.word + "+" + list.join(", "));
    });
    setState(() => isLoading = false);
  }

  getAllCategories() async {
    clearList();
    setState(() => isLoading = true);
    final SharedPreferences sp = await _prefs;
    listCategories = await CategoryTable()
        .getAllCategoriesByUser(sp.getString('username') as String);
    listCategories.forEach(
      (element) {
        autoList.add("Bộ:" + element.name);
      },
    );
    setState(() => isLoading = false);
  }

  static String _displayStringForOption(dynamic option) =>
      option is CategoryModel ? option.name : option.word;

  @override
  Widget build(BuildContext context) {
    // isLoading ? "" : autoList.addAll(autoSenList);
    return isLoading
        ? const CircularProgressIndicator()
        : LayoutBuilder(
            builder: (context, constraints) => RawAutocomplete<String>(
              key: _autocompleteKey,
              focusNode: _focus,
              textEditingController: _controller,
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return Focus(
                  onFocusChange: (value) {
                    setState(() {
                      getAllCategories();
                      getAllSentences();
                    });
                  },
                  child: TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  decoration: InputDecoration(
                      hintText: "Tìm kiếm",
                      contentPadding: EdgeInsets.all(16),
                      hintStyle: TextStyle(fontSize: 14),
                      suffixIcon: Icon(
                        Icons.search,
                        color: _isTapped ? primaryColor : op20BlackColor,
                      ),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: op20BlackColor)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: op20BlackColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: primaryColor))),
                ));
              },
              optionsViewBuilder: (context, onSelected, options) {
                List<String> categories = [];
                List<String> sentences = [];
                for (var element in options) {
                  element.indexOf("Câu:") == 0
                      ? sentences.add(element)
                      : categories.add(element);
                }
                double boxHeight = 288.0;
                return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                        elevation: 10.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(8.0)),
                        ),
                        // color: primaryColor,
                        child: SizedBox(
                            height: boxHeight,
                            width: constraints.biggest.width,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(16),
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  const Text("Câu đã lưu",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 14,
                                          fontWeight: w600Font)),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          Divider(),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: sentences.length,
                                      // padding: const EdgeInsets.all(8),
                                      itemBuilder: (context, index) {
                                        final String option =
                                            sentences.elementAt(index);
                                        return GestureDetector(
                                          onTap: () {
                                            onSelected(option);
                                          },
                                          child: Row(
                                              children: [
                                                Icon(Icons.search),
                                                Expanded(
                                                    child: ListTile(
                                                  title: Text(
                                                      option.substring(
                                                          option.indexOf(
                                                                  "Câu:") +
                                                              4,
                                                          option.indexOf("+")),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: w400Font,
                                                          color:
                                                              op80BlackColor)),
                                                  subtitle: Text(
                                                      option.substring(
                                                          option.indexOf("+") +
                                                              1),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              w500Font)),
                                                  // minVerticalPadding: 12,
                                                  contentPadding:
                                                      EdgeInsets.only(left: 10),
                                                ))
                                              ]),
                                        );
                                      }),
                                  const Text("Bộ câu của bạn",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 14,
                                          fontWeight: w600Font)),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                            height: 1,
                                          ),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: categories.length,
                                      // padding: const EdgeInsets.all(8),
                                      itemBuilder: (context, index) {
                                        final String option =
                                            categories.elementAt(index);
                                        return GestureDetector(
                                          onTap: () {
                                            onSelected(option);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.search),
                                              Expanded(
                                                  child: ListTile(
                                                title: Text(option.substring(3),
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ))
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ))));
              },
              onSelected: (selectedString) async {
                if (selectedString.indexOf("Câu:") == 0) {
                  SentenceModel temp = await SentenceTable().getSentence(
                      selectedString.substring(4, selectedString.indexOf('+')));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SentenceDetailScreen(
                                title: "",
                                sentence: temp,
                              ))).then((value) {
                    selectedString = '';
                    setState(() {
                      _controller.clear();
                      autoList.clear();
                      getAllSentences();
                      getAllCategories();
                    });
                  });
                } else {
                  final SharedPreferences sp = await _prefs;
                  String catName = selectedString.substring(3);
                  CategoryModel tempCat = await CategoryTable()
                      .getCategory(sp.getString("username") as String, catName);
                  List<SentenceModel> sens = await SentenceTable()
                      .getAllSentencesByCategory(tempCat.id as int);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyListScreen(
                              title: catName,
                              list: sens,
                              category: tempCat))).then((value) {
                    selectedString = '';
                    setState(() {
                      _controller.clear();
                      autoList.clear();
                      getAllSentences();
                      getAllCategories();
                    });
                  });
                }
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return autoList.where((element) => element.indexOf("Câu:") == 0
                    ? element
                        .substring(4, element.indexOf("+"))
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase())
                    : element
                        .substring(3)
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
              },
            ),
          );
  }
}
