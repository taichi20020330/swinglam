import 'package:flutter/material.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/views/profile/pages/profile_page.dart';

import '../../../data_models/user.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileOpenMode profileMode;
  final User? selectedUser;

  ProfileScreen({required this.profileMode,  this.selectedUser});

  @override
  Widget build(BuildContext context) {
    return ProfilePage(profileMode: profileMode, selectedUser: selectedUser);
  }
}
