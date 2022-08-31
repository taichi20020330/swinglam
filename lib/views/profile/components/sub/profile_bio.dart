import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/view_models/profile_view_model.dart';
import 'package:swinglam/views/profile/screens/profile_edit_screen.dart';

import '../../../../style.dart';

class ProfileBio extends StatelessWidget {

  final ProfileOpenMode profileMode;

  ProfileBio({required this.profileMode});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(profileUser.inAppUserName),
          Text(profileUser.bio, style: profileBioTextStyle),
          SizedBox(height: 16,),
          SizedBox(
              width: double.infinity,
            child: _button(context, profileMode),
          )
        ],
      ),
    );
  }

  _button(BuildContext context, profileMode) {
    final profileViewModel = context.read<ProfileViewModel>();
    final isFollowing = profileViewModel.isFollowing;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
        onPressed: () => (profileMode == ProfileOpenMode.MYSELF)
            ?  _openProfileEditScreen(context)
            : isFollowing ?  _unFollow(context) : _follow(context),
        child:
        (profileMode == ProfileOpenMode.MYSELF)
        ? Text("プロフィールを編集する")
            : isFollowing ?  Text("フォローをやめる") : Text("フォローする"),
    );
  }

  _openProfileEditScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => ProfileEditScreen()));
  }

  _follow(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.follow();
  }

  _unFollow(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.unFollow();
  }
}
