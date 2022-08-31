import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../../style.dart';
import '../../../../view_models/profile_view_model.dart';
import '../../../who_care/screens/who_care_screen.dart';

class ProfileRecords extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    return Row(
      children: [
        FutureBuilder(
        future: profileViewModel.getNumberOfPosts(),
        builder: (context, AsyncSnapshot<int> snapshot){
          final numberOfPosts = snapshot.data;
          return _userRecordWidget(
              context: context,
              score: snapshot.hasData ? numberOfPosts! : 0,
              title: "投稿",
         );
        }),
        FutureBuilder(
            future: profileViewModel.getNumberOfFollowers(),
            builder: (context, AsyncSnapshot<int> snapshot){
              return _userRecordWidget(
                  context: context,
                  score: snapshot.hasData ? snapshot.data! : 0,
                  title: "フォロワー",
                  whoCareMode: WhoCareMode.FOLLOWINGS
              );
            }),    FutureBuilder(
            future: profileViewModel.getNumberOfFollowings(),
            builder: (context, AsyncSnapshot<int> snapshot){
              return _userRecordWidget(
                context: context,
                score: snapshot.hasData ? snapshot.data! : 0,
                title: "フォロー",
                whoCareMode: WhoCareMode.FOLLOW
                  );
            }),
      ],
    );
  }

  _userRecordWidget({
    required BuildContext context,
    required int score,
    required String title,
    WhoCareMode? whoCareMode
  }) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => (whoCareMode == null) ? null : _checkLikeUsers(context, whoCareMode),
        child: Column(
          children: [
            Text(score.toString(), style: profileRecordTextStyle),
            Text(title, style: profileTitleTextStyle),
          ],
        ),
      ),
    );
  }

  _checkLikeUsers(BuildContext context, WhoCareMode whoCareMode) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => WhoCareScreen(
            id: profileUser.userId,
            whoCareMode: whoCareMode)));
  }
}

