import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/contants.dart';
import 'package:speekup_v2/db/category_table.dart';
import 'package:speekup_v2/db/user_table.dart';
import 'package:speekup_v2/model/category.dart';
import 'package:speekup_v2/model/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:speekup_v2/screens/emergency/emergency_screen.dart';
import 'package:speekup_v2/screens/home/components/carousel_slider.dart';
import 'package:speekup_v2/screens/common/search_bar.dart';
import 'package:speekup_v2/screens/home/components/edit_info_dialog.dart';
import 'package:speekup_v2/screens/login.dart/login_screen.dart';
import 'package:speekup_v2/screens/my_list/my_list.dart';
import 'package:speekup_v2/screens/splash_screen.dart';
import 'package:speekup_v2/screens/text_to_speed/text_to_speed_screen.dart';

import 'components/change_password_dialog.dart';

final List<String> imgList = [
  'assets/images/img_1.png',
  'assets/images/img_2.png',
  'assets/images/img_3.png',
  'assets/images/img_4.png',
];

final List<String> guild = [
  'Chuyển đổi văn bản thành giọng nói:',
  'Nhập văn bản vào ô trống.',
  'Chọn “Phát văn bản” để phát giọng nói với nội dung vừa nhập.',
  'Chọn “Lưu câu” để thêm nội dung vừa nhập vào bộ câu dữ liệu. Sau đó, chọn bộ câu mà bạn muốn lưu văn bản vừa nói vào hoặc chọn “tạo mới” để lưu vào một bộ câu mới.',
  'Chuyển giọng nói thành văn bản:',
  'Bấm vào hình micro ở góc dưới bên phải màn hình. Cửa sổ popup “Chuyển đổi giọng nói” hiện ra.',
  'Bấm “Xong” để lưu lại văn bản. Bấm “Hủy” để hủy bỏ thao tác chuyển đổi.'
];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<CategoryModel> listCategories = [];
  bool isLoading = false;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    getUser();
    getAllCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getUser() async {
    setState(() => isLoading = true);
    final SharedPreferences sp = await _prefs;
    user = await UserTable().getUser(sp.getString('username')!);
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  getAllCategories() async {
    setState(() => isLoading = true);
    final SharedPreferences sp = await _prefs;
    listCategories = await CategoryTable()
        .getAllCategoriesByUser(sp.getString('username') as String);
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future setLogoutState() async {
    final SharedPreferences sp = await _prefs;
    sp.setBool("logged", false);
    sp.remove('username');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: isLoading
            ? SplashScreen()
            : Scaffold(
                backgroundColor: Colors.white,
                drawer: Drawer(
                    width: 240,
                    child: Padding(
                        padding: EdgeInsets.only(top: 23, left: 24, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.close_rounded,
                                          color: primaryColor))),
                            ),
                            SizedBox(height: 10),
                            Text(
                              user.fullname,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 28,
                                  fontWeight: w600Font),
                            ),
                            SizedBox(height: 25),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showChangePwdDialog(context, user);
                                },
                                child: Text("Đổi mật khẩu",
                                    style: TextStyle(
                                        color: op80BlackColor,
                                        fontWeight: w600Font,
                                        fontSize: 14))),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                          context: context,
                                          builder: (context) => Center(
                                              child: editDialogContent(
                                                  context, user)))
                                      .then((value) => getUser());
                                },
                                child: Text("Sửa thông tin cá nhân",
                                    style: TextStyle(
                                        color: op80BlackColor,
                                        fontWeight: w600Font,
                                        fontSize: 14))),
                            Spacer(),
                            Padding(
                                padding: EdgeInsets.only(right: 24),
                                child: OutlinedButton(
                                    onPressed: () async {
                                      setLogoutState();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                    child: Text("Đăng xuất"),
                                    style: OutlinedButton.styleFrom(
                                      primary: primaryColor,
                                      side: BorderSide(color: primaryColor),
                                      minimumSize: Size.fromHeight(40),
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w600),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    )))
                          ],
                        ))),
                appBar: buildAppBar(),
                resizeToAvoidBottomInset: false,
                body: Body(),
              ));
  }

  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 48,
        leading: Builder(
            builder: (context) => Padding(
                padding: const EdgeInsets.only(left: 26),
                child: GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.person_outlined, color: Colors.black),
                        SizedBox(width: 10),
                        Text(user.username,
                            style: TextStyle(color: Colors.black)),
                      ],
                    )))),
        leadingWidth: 200,
        titleSpacing: 0,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.help_outline, color: primaryColor),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Center(
                        child: Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    "Hướng dẫn sử dụng",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: w600Font),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                ),
                                ExpansionTile(
                                    title: Text("Dịch cấu trúc"),
                                    children: [Divider(), Text("")],
                                    collapsedTextColor: op80BlackColor,
                                    textColor: op80BlackColor,
                                    iconColor: primaryColor),
                                ExpansionTile(
                                  title: Text("Chuyển đổi văn bản - giọng nói"),
                                  children: [
                                    Divider(height: 1),
                                    Text("Bước 1: Tại màn hình trang chủ, chọn \"Chuyển đổi văn bản - giọng nói\".\nBước 2:\n" +
                                        '\t-\tChuyển đổi văn bản thành giọng nói:\n' +
                                        '\t-\tNhập văn bản vào ô trống.\n' +
                                        '\t-\tChọn \“Phát văn bản\” để phát giọng nói với nội dung vừa nhập.\n' +
                                        '\t-\tChọn \“Lưu câu” để thêm nội dung vừa nhập vào bộ câu dữ liệu. Sau đó, chọn bộ câu mà bạn muốn lưu văn bản vừa nói vào hoặc chọn \“tạo mới\” để lưu vào một bộ câu mới.\n' +
                                        '\t-\tChuyển giọng nói thành văn bản:\n' +
                                        '\t-\tBấm vào hình micro ở góc dưới bên phải màn hình. Cửa sổ popup “Chuyển đổi giọng nói” hiện ra.\n' +
                                        '\t-\tBấm \“Xong\” để lưu lại văn bản. Bấm \“Hủy\” để hủy bỏ thao tác chuyển đổi.\n'),
                                  ],
                                  collapsedTextColor: op80BlackColor,
                                  textColor: op80BlackColor,
                                  iconColor: primaryColor,
                                  childrenPadding: EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Xong",
                                        style: TextStyle(color: primaryColor)),
                                    style: TextButton.styleFrom(
                                        minimumSize: Size.fromHeight(36),
                                        padding: EdgeInsets.zero))
                              ],
                            ))));
              })
        ]);
  }

  Widget Body() {
    return Column(children: <Widget>[
      //Search bar
      Padding(padding: EdgeInsets.all(24), child: SearchBar()),
      SizedBox(height: 20),
      //Welcome text
      Padding(
          padding: EdgeInsets.only(left: 24),
          child: Align(
              alignment: Alignment.centerLeft,
              // widthFactor: 1.45,
              child: Text("Chào ${user.fullname},",
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 32)))),
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
              child: Column(
                children: [
                  buildButtons(
                      context,
                      Icon(Icons.mic_none_outlined, color: primaryColor),
                      "Chuyển đổi văn bản - giọng nói",
                      TextToSpeedScreen()),
                  SizedBox(
                    height: 16,
                  ),
                  buildButtons(
                      context,
                      Icon(Icons.sync_alt_rounded, color: primaryColor),
                      "Dịch cấu trúc",
                      HomeScreen()),
                  SizedBox(
                    height: 16,
                  ),
                  buildButtons(
                      context,
                      Icon(Icons.star_border_rounded, color: primaryColor),
                      "Câu của bạn",
                      MyListScreen(title: "Câu của bạn", list: listCategories)),
                  SizedBox(
                    height: 16,
                  ),
                  buildButtons(
                      context,
                      Icon(Icons.warning_amber_outlined, color: primaryColor),
                      "Bộ câu khẩn cấp",
                      EmergencyScreen()),
                ],
              ))),
      //Sign out button
      // Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 24),
      //     child: )
    ]);
  }

  //Render redirect button
  InkWell buildButtons(
      BuildContext context, Icon icon, String text, StatefulWidget nextScreen) {
    return InkWell(
        onTap: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => nextScreen))
              .then((value) async {
            await getAllCategories();
            setState(() {});
          });
        },
        child: Container(
            width: 312,
            height: 48,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: op20BlackColor)),
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
