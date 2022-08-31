import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/view_models/feed_view_model.dart';

import '../../../../data_models/comment.dart';
import '../../../../data_models/post.dart';
import '../../../../data_models/user.dart';
import '../../../../functinos.dart';
import '../../../../style.dart';
import '../../../comments/screens/comment_screen.dart';
import '../../../commons/components/comment_rich_text.dart';

class FeedPostCommentsPart extends StatelessWidget {
  final Post post;
  final User postUser;

  FeedPostCommentsPart({required this.post, required this.postUser});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentRichText(
            title: postUser.inAppUserName,
            content: post.caption,
          ),
          InkWell(
            onTap: () => _openCommentScreen(context, post),
            child: FutureBuilder(
              future: feedViewModel.getComments(post.postId),
              builder: (context, AsyncSnapshot<List<Comment>> snapshot){
                if(snapshot.hasData && snapshot.data != null){
                  final comments = snapshot.data!;
                  return Text("${comments.length} コメント", style: userCardCommentStyle);
                } else {
                  return Container();
                }
              },
            )

          ),
          Text(
              createTimeAgoString(post.PostDateTime),
              style: userCardCommentStyle)
        ],
      ),
    );
  }

  _openCommentScreen(BuildContext context, post) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => CommentScreen(post: post, postUser: postUser,))
    );
  }
}
