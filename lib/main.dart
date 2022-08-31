import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/di/providers.dart';
import 'package:swinglam/firebase_options.dart';
import 'package:swinglam/views/home_screen.dart';
import 'package:swinglam/style.dart';
import 'package:swinglam/view_models/login_view_model.dart';
import 'package:swinglam/views/login/screens/login_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'generated/l10n.dart';


void main() async {
  timeago.setLocaleMessages("ja", timeago.JaMessages()); // Add french messages

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
        providers: globalProviders,
          child: MyApp())
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.read<LoginViewModel>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
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
      home: FutureBuilder(
        future: loginViewModel.isSignIn(),
        builder: (context, AsyncSnapshot<bool> snapshot){
          if(snapshot.hasData && snapshot.data == true){
            return HomeScreen();
          }else {
            return LoginScreen();
          }
        },
      ),


    );

  }
}
