import 'package:flutter/material.dart';
import 'package:swinglam/models/repositories/user_repository.dart';

import '../data_models/user.dart';

class SearchViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  List<User> soughtUsers = [];

  SearchViewModel({required this.userRepository});

  Future<void> searchUsers(String query) async {
    soughtUsers = await userRepository.searchUsers(query);
    notifyListeners();
  }

}