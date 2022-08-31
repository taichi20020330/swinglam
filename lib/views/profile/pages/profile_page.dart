import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/view_models/profile_view_model.dart';

import '../../../constants.dart';
import '../../../data_models/user.dart';
import '../components/profile_detail_part.dart';
import '../components/profile_posts_grid_part.dart';

class ProfilePage extends StatelessWidget {

  final ProfileOpenMode profileMode;
  final User? selectedUser;

  ProfilePage({required this.profileMode,  this.selectedUser});


  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.setProfileUser(profileMode, selectedUser);
    Future(() => profileViewModel.getPosts(profileMode));

    return Scaffold(

      body: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          final profileUser = model.profileUser;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                  title:Text(profileUser.inAppUserName),
                pinned: true,
                floating: true,
                actions: [
                ],
                expandedHeight: 280.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: ProfileDetailPart(profileMode: profileMode),
                ),
              ),
              ProfilePostGridPart(posts: profileViewModel.posts)
            ],
          );
        },
      ),
    );
  }
}
