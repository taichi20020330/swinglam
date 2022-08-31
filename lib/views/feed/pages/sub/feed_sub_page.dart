import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:swinglam/view_models/feed_view_model.dart';

import '../../../../constants.dart';
import '../../../../data_models/user.dart';
import '../../common/feed_post_tile.dart';


class FeedSubPage extends StatelessWidget {
  final feedOpenMode feedMode;
  final User? feedUser;
  final int index;

  FeedSubPage({required this.feedMode, this.feedUser, required this.index});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FeedViewModel>();
    viewModel.setFeedUser(feedMode, feedUser);

    Future(() => viewModel.getPosts(feedMode));


    return Consumer<FeedViewModel>(
        builder: (context, model, child){
          if(model.isProcessing == true){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return (model.posts == null)
                ? Container()
                :  RefreshIndicator(
              onRefresh: () => model.getPosts(feedMode),
                  child: ScrollablePositionedList.builder(
                    initialScrollIndex: index,
                    physics: AlwaysScrollableScrollPhysics(),
              itemCount: model.posts.length,
              itemBuilder: (context, index) {
                  return FeedPostTile(
                      post: model.posts[index],
                      from: feedMode
                  );
              }
            ),
                );
          }
        });
  }
}
