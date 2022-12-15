import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/db/category_table.dart';
import 'package:speekup_v2/db/sentence_table.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/model/sentence.dart';
import 'package:speekup_v2/screens/my_list/my_list.dart';

import '../../contants.dart';
import 'components/body.dart';

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreen createState() => _EmergencyScreen();
}

class _EmergencyScreen extends State<EmergencyScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<CategoryModel> listCategories = [];
  List<SentenceModel> listSentences = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListCategories();
  }

  void getListCategories() async {
    setState(() => isLoading = true);
    final SharedPreferences sp = await _prefs;
    listCategories = await CategoryTable()
        .getEmergencyCategories(sp.getString('username') as String);
    setState(() => isLoading = false);
  }

  getAllSentences(int categoryID) async {
    setState(() => isLoading = true);
    listSentences = await SentenceTable().getAllSentencesByCategory(categoryID);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding: EdgeInsets.all(24),
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 16,
                ),
                itemCount: listCategories.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    getAllSentences(listCategories[index].id as int);
                    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyListScreen(
                  title: listCategories[index].name, list: listSentences, category: listCategories[index], isDeletable: false,)));
                  },
                  child: Container(
                  height: 56,
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
                      Text(listCategories[index].name,
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14)),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_outlined,
                          color: op40BlackColor, size: 15)
                    ],
                  ),
                )),
              )),
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 6,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: primaryColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 85,
        centerTitle: true,
        title: Text(
          "Bộ câu khẩn cấp",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
        ));
  }
}
