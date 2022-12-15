import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/contants.dart';
import 'package:speekup_v2/screens/home/home_screen.dart';
import 'package:speekup_v2/screens/login.dart/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> logged;

  @override
  void initState() {
    logged = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('logged') ?? false);
    });
    // _loadingSplashScreen();
    super.initState();
  }

  _loadingSplashScreen() async {
    await Future.delayed(
      const Duration(microseconds: 1500),(){}
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: logged,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
                child: Scaffold(
              backgroundColor: primaryColor,
              body: Center(
                  child: Text("SPEEKUP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: w700Font))),
            ));
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data! ? HomeScreen() : LoginScreen();
            }
        }
      },
    );
  }
}
