import 'package:flutter/material.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/views/feed/pages/sub/feed_sub_page.dart';

import '../../../data_models/user.dart';

class FeedScreen extends StatelessWidget {
  final User feedUser;
  final int index;
  final feedOpenMode feedMode;

  FeedScreen({required this.feedUser, required this.index, required this.feedMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投稿"),
      ),
      body: FeedSubPage(
        feedMode: feedMode,
        index: index,
        feedUser: feedUser,
      ),
    );
  }
}
