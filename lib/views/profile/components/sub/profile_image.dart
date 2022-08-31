import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/view_models/profile_view_model.dart';
import 'package:swinglam/views/commons/components/circle_photo.dart';

class ProfileImage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;
    return CirclePhoto(
        imageUrl: profileUser.photoUrl,
        isImageFromFile: false,
      radius: 30.0,
    );
  }
}
