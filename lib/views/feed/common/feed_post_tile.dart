import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/view_models/feed_view_model.dart';
import 'package:swinglam/views/feed/common/sub/feed_post_commens_part.dart';
import 'package:swinglam/views/feed/common/sub/feed_post_likers_part.dart';
import 'package:swinglam/views/feed/common/sub/image_from_url.dart';

import '../../../data_models/post.dart';
import '../../../data_models/user.dart';
import 'sub/feed_post_header_part.dart';

class FeedPostTile extends StatelessWidget {
  final feedOpenMode from;
  final Post post;


  FeedPostTile({
    required this.from, required this.post
});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder(
        future: feedViewModel.getPostUserInfo(post.userId),
        builder: (context, AsyncSnapshot<User> snapshot){
          if(snapshot.hasData && snapshot.data != null){
            final postUser = snapshot.data;
            final currentUser = feedViewModel.currentUser;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FeedPostHeaderPart(
                  currentUser: currentUser,
                  postUser: postUser!,
                  post: post,
                  feedMode: from,
                ),
                ImageFromUrl(imageUrl: post.imageUrl),
                FeedPostLikersPart(post:post, postUser: postUser,),
                FeedPostCommentsPart(
                  post: post,
                  postUser: postUser,
                ),
              ],
            );
          } else {
           return  Container();
          }
        },
      ),
    );
  }
}
