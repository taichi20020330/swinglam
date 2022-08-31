import 'package:flutter/material.dart';
import 'package:swinglam/models/repositories/user_repository.dart';

import '../data_models/user.dart';

class WhoCareViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  WhoCareViewModel({required this.userRepository});

  List<User> careMeUsers = [];

  User get currentUser => UserRepository.currentUser!;


  Future<void> getUsersByCare(String id, mode) async {
    careMeUsers = await userRepository.getUsersByCare(id, mode);
    notifyListeners();
  }

}