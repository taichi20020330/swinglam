import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/view_models/feed_view_model.dart';
import 'package:swinglam/views/comments/screens/comment_screen.dart';
import 'package:swinglam/views/who_care/screens/who_care_screen.dart';

import '../../../../data_models/like.dart';
import '../../../../data_models/post.dart';
import '../../../../data_models/user.dart';
import '../../../../style.dart';

class FeedPostLikersPart extends StatelessWidget {
  final Post post;
  final User postUser;

  FeedPostLikersPart({required this.post, required this.postUser});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: FutureBuilder(
          future: feedViewModel.getLikeResults(post.postId),
          builder: (context, AsyncSnapshot<LikeResult> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final result = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      (result.isLikedToThisPost)
                          ? IconButton(
                              onPressed: () => _unLikeIt(context),
                              icon: FaIcon(FontAwesomeIcons.solidHeart))
                          : IconButton(
                              onPressed: () => _likeIt(context),
                              icon: FaIcon(FontAwesomeIcons.heart)),
                      IconButton(
                        onPressed: () => _openCommentScreen(context, post),
                        icon: FaIcon(FontAwesomeIcons.comment),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _checkLikeUsers(context),
                      child: Text("${result.likes.length} いいね", style: userCardLikeStyle))
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }

  _openCommentScreen(BuildContext context, post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CommentScreen(
                  post: post,
                  postUser: postUser,
                )));
  }

  _likeIt(BuildContext context) async {
    final feedViewModel = context.read<FeedViewModel>();
    await feedViewModel.likeIt(post);
  }

  _unLikeIt(BuildContext context) async {
    final feedViewModel = context.read<FeedViewModel>();
    await feedViewModel.unLikeIt(post);
  }

  _checkLikeUsers(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => WhoCareScreen(id: post.postId, whoCareMode: WhoCareMode.LIKE)));
  }
}
