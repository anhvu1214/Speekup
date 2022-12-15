import 'package:flutter/material.dart';
import 'package:speekup_v2/screens/login.dart/sign_up_screen.dart';
import 'package:speekup_v2/screens/sentence_detail.dart/sentence_detail_screen.dart';
import 'package:speekup_v2/screens/splash_screen.dart';
import 'package:speekup_v2/screens/text_to_speed/text_to_speed_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Color.fromARGB(255, 0, 0, 0)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

