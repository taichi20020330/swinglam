import 'package:flutter/material.dart';

import '../models/repositories/user_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  bool isLoading = false;
  bool isSuccessful = false;

  LoginViewModel({required this.userRepository});

  Future<bool> isSignIn() async {
    return await userRepository.isSignIn();
  }

  Future<void> singIn() async {
    isLoading = true;
    notifyListeners();

    isSuccessful = await userRepository.signIn();

    isLoading = false;
    isSuccessful = true;

  }
}