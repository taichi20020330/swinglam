import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swinglam/views/commons/components/confirm_dialog.dart';
import 'package:swinglam/views/commons/components/user_card.dart';
import 'package:swinglam/views/feed/screens/feed_post_edit_screen.dart';
import 'package:swinglam/views/profile/screens/profile_screen.dart';

import '../../../../constants.dart';
import '../../../../data_models/post.dart';
import '../../../../data_models/user.dart';
import '../../../../view_models/feed_view_model.dart';

class FeedPostHeaderPart extends StatelessWidget {
  final User postUser;
  final Post post;
  final User currentUser;
  final feedOpenMode feedMode;

  FeedPostHeaderPart({
    required this.currentUser, required this.post, required this.postUser, required this.feedMode
});

  @override
  Widget build(BuildContext context) {
    return UserCard(
      imageUrl: postUser.photoUrl,
      onTap: () => _openProfileScreen(context, postUser),
      title: postUser.inAppUserName,
      subTitle: post.locationString,
      trailing: PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (PostMenu menu) => _onPopupMenuSelected(context, menu),
        itemBuilder: (context) {
          if(postUser.userId == currentUser.userId){
            return [
              PopupMenuItem(
                  value: PostMenu.EDIT,
                  child: Text("編集")
              ),
              PopupMenuItem(
                  value: PostMenu.DELETE,
                  child: Text("削除")
              ),
              PopupMenuItem(
                  value: PostMenu.SHARE,
                  child: Text("シェア")
              ),
            ];
          } else {
            return [
              PopupMenuItem(
                  value: PostMenu.SHARE,
                  child: Text("シェア")
              ),
            ];
          }
        },
      ),
    );
  }

  _onPopupMenuSelected(BuildContext context, PostMenu menu) {
    switch(menu){
      case PostMenu.EDIT:
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => FeedPostEditScreen(post: post, postUser: postUser, feedMode: feedMode))
        );
        break;
      case PostMenu.SHARE:
        Share.share(post.imageUrl, subject: post.caption);
        break;
      case PostMenu.DELETE:
        showConfirmDialog(
            context: context,
            title: "投稿の削除",
            content: "投稿を削除してもよろしいですか？",
            onConfirmed: (onConfirmed){
              if(onConfirmed){
                _deletePost(context, post);
              }
            }
        );
    }
  }

  void _deletePost(BuildContext context, Post post) async {
    final feedViewModel = context.read<FeedViewModel>();
    feedViewModel.deletePost(post, feedMode);

  }

  _openProfileScreen(BuildContext context, User postUser) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ProfileScreen(
          //TODO
            profileMode: postUser.userId == currentUser.userId
                ? ProfileOpenMode.MYSELF
                : ProfileOpenMode.OTHER,
            selectedUser: postUser
        )
    ));
  }
}
