import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/views/comments/components/comment_display_part.dart';
import 'package:swinglam/views/comments/components/comment_input_text_field.dart';
import 'package:swinglam/views/commons/components/confirm_dialog.dart';

import '../../../data_models/post.dart';
import '../../../data_models/user.dart';
import '../../../view_models/comment_view_model.dart';

class CommentScreen extends StatelessWidget {
  final Post post;
  final User postUser;

  CommentScreen({required this.post, required this.postUser});

  @override
  Widget build(BuildContext context) {
    final commentViewModel = context.read<CommentViewModel>();
    Future(() => commentViewModel.getComments(post.postId));

    return Scaffold(
      appBar: AppBar(
        title: Text("コメント一覧"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CommentDisplayPart(
              postDateTime: post.PostDateTime,
              title: postUser.inAppUserName,
              content: post.caption,
              postUserPhotoUrl: postUser.photoUrl,
            ),
            Consumer<CommentViewModel>(
                builder: (context, model, child){
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.comments.length,
                      itemBuilder: (context, index) {
                      final comment = model.comments[index];
                      final commentUserId = comment.commentUserId;
                      return FutureBuilder(
                        future: model.getUserInfoByComment(commentUserId),
                        builder: (context, AsyncSnapshot<User> snapshot){
                          if(snapshot.hasData && snapshot.data != null){
                            final commentUser = snapshot.data! ;
                            return CommentDisplayPart(
                                postUserPhotoUrl: commentUser.photoUrl,
                                title: commentUser.inAppUserName,
                                content: comment.comment,
                                postDateTime: comment.commentDateTime,
                              onLongPressed: () => showConfirmDialog(
                                  context: context,
                                  title: "削除",
                                  content: "このコメントを削除してよろしいですか？",
                                  onConfirmed: (isConfirmed){
                                    if(isConfirmed){
                                      _deleteComment(context, index);
                                    }


                                  }
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    });
                }
            ),
            CommentInputTextField(post: post)
          ],
        ),
      ),
    );
  }

  void _deleteComment(BuildContext context, int commentIndex) async {
    final commentViewModel = context.read<CommentViewModel>();
    await commentViewModel.deleteComment(post,commentIndex);
  }
}
