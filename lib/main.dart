import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swinglam/firebase_options.dart';
import 'package:swinglam/screens/home_screen.dart';
import 'package:swinglam/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.white30
          )
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.white
        ),
        iconTheme:IconThemeData(
          color: Colors.white
        ),
        fontFamily: RegularFont,
      ),
      home: HomeScreen(),


    );

  }
}
