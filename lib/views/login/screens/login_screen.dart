import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/views/home_screen.dart';
import 'package:swinglam/view_models/login_view_model.dart';
import 'package:swinglam/views/commons/components/buttonWithIcon.dart';

import '../../../style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginViewModel>(
          builder: (context, model, child){
            return model.isLoading
            ? CircularProgressIndicator()
              : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Swinglam", style: loginTitleTextStyle,),
                SizedBox(height: 8.0),
                ButtonWithIcon(
                  iconData: FontAwesomeIcons.arrowRightToBracket,
                  label: "サインイン",
                  onPressed: () => login(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  login(BuildContext context) async {
    final loginViewModel = context.read<LoginViewModel>();
    await loginViewModel.singIn();
    if(!loginViewModel.isSuccessful){
      Fluttertoast.showToast(msg: "エラーでっせ。");
      return;
    }
    _openHomeScreen(context);
  }

  void _openHomeScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => HomeScreen()
    )
    );
  }

}
