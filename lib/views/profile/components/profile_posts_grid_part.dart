import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/views/feed/common/sub/image_from_url.dart';

import '../../../data_models/post.dart';
import '../../../view_models/profile_view_model.dart';
import '../../feed/screens/feed_screen.dart';

class ProfilePostGridPart extends StatelessWidget {
  final List<Post> posts;

  ProfilePostGridPart({required this.posts});

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
        crossAxisCount: 3,
        children: posts.isEmpty
        ? [Container()]
        : List.generate(posts.length,
                (int index) =>
                    InkWell(
                      onTap: () => _openFeedScreen(context, index),
                        child: ImageFromUrl(imageUrl: posts[index].imageUrl)
                    )
        )

    );
  }

  _openFeedScreen(BuildContext context, int index) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => FeedScreen(
          index: index,
          feedMode: feedOpenMode.FROM_PROFILE,
          feedUser:profileUser,
        ))
    );

  }
}
