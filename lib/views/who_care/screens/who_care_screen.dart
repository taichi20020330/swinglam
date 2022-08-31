import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/view_models/who_care_view_model.dart';
import 'package:swinglam/views/commons/components/user_card.dart';

import '../../../data_models/user.dart';
import '../../profile/screens/profile_screen.dart';

class WhoCareScreen extends StatelessWidget {
  final String id;
  final WhoCareMode whoCareMode;

  WhoCareScreen({required this.id, required this.whoCareMode});

  @override
  Widget build(BuildContext context) {
    final whoCareViewModel = context.read<WhoCareViewModel>();

    Future(() => whoCareViewModel.getUsersByCare(id, whoCareMode));

    return Scaffold(
      appBar: AppBar(
        title: _titleString(context, whoCareMode),
      ),
      body: Consumer<WhoCareViewModel>(
        builder: (context, model, child){
          return model.careMeUsers.isEmpty
              ? Container()
              : ListView.builder(
              itemBuilder: (context, int index){
                final user =  model.careMeUsers[index];
                return UserCard(
                    imageUrl: user.photoUrl,
                    title: user.inAppUserName,
                    subTitle: user.bio,
                  onTap: () => _openProfileScreen(
                    context, user
                  ),
                );
              },
            itemCount: model.careMeUsers.length,
          );
        },
      ),
    );
  }

  _titleString(BuildContext context, WhoCareMode whoCareMode) {
    var titleText = "";
    switch (whoCareMode) {
      case WhoCareMode.LIKE:
        return Text("いいね");
        break;
      case WhoCareMode.FOLLOW:
        return Text("フォロー中");
        break;
      case WhoCareMode.FOLLOWINGS:
        return Text("フォロワー");
        break;
    }
  }

  _openProfileScreen(BuildContext context, User postUser) {
    final whoCareViewModel = context.read<WhoCareViewModel>();

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ProfileScreen(
            profileMode: postUser.userId == whoCareViewModel.currentUser.userId
                ? ProfileOpenMode.MYSELF
                : ProfileOpenMode.OTHER,
            selectedUser: postUser
        )
    ));
  }
}
