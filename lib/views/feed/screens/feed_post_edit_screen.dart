import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/view_models/feed_view_model.dart';
import 'package:swinglam/views/commons/components/confirm_dialog.dart';
import 'package:swinglam/views/commons/components/user_card.dart';
import 'package:swinglam/views/post/components/post_caption_part.dart';

import '../../../constants.dart';
import '../../../data_models/post.dart';
import '../../../data_models/user.dart';

class FeedPostEditScreen extends StatelessWidget {
  final Post post;
  final User postUser;
  final feedOpenMode feedMode;

  FeedPostEditScreen(
      {required this.post, required this.postUser, required this.feedMode});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    return Consumer<FeedViewModel>(
      builder: (_, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: model.isProcessing
                ? Container()
                : IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
            title: model.isProcessing
            ? Text("編集中...")
            : Text("投稿の編集"),
            actions: [
              model.isProcessing
                  ? Container()
                  : IconButton(
                      onPressed: () => showConfirmDialog(
                          context: context,
                          title: "投稿の編集",
                          content: "投稿を編集してもよろしいですか？",
                          onConfirmed: (isConfirmed) {
                            if (isConfirmed) {
                              _updatePost(context);
                            }
                          }),
                      icon: Icon(Icons.done))
            ],
          ),
          body: model.isProcessing
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      UserCard(
                          imageUrl: postUser.photoUrl,
                          title: postUser.inAppUserName,
                          subTitle: post.locationString),
                      PostCaptionPart(
                        from: uploadOpenMode.FROM_FEED,
                        post: post,
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }

  void _updatePost(BuildContext context) async {
    final feedViewModel = context.read<FeedViewModel>();
    await feedViewModel.updatePost(post, feedMode);
    Navigator.pop(context);
  }
}
