import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/view_models/comment_view_model.dart';
import 'package:swinglam/views/commons/components/circle_photo.dart';

import '../../../data_models/post.dart';
import '../../../style.dart';

class CommentInputTextField extends StatefulWidget {
  final Post post;

  CommentInputTextField({required this.post});

  @override
  State<CommentInputTextField> createState() => _CommentInputTextFieldState();
}

class _CommentInputTextFieldState extends State<CommentInputTextField> {
  final _commentInputTextController = TextEditingController();
  bool isCommentIn = false;


  @override
  void initState() {
    _commentInputTextController.addListener(_onCommentChange);

    super.initState();
  }

  @override
  void dispose() {
    _commentInputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme
        .of(context)
        .cardColor;
    final commentViewModel = context.read<CommentViewModel>();
    final commenter = commentViewModel.currentUser;


    return Card(
      color: cardColor,
      child: ListTile(
        leading: CirclePhoto(
          isImageFromFile: false,
          imageUrl: commenter.photoUrl,
        ),
        title: TextField(
          maxLines: null,
            controller: _commentInputTextController,
            style: commentInputTextStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "コメントを入力...",
            )
        ),
        trailing: TextButton(
          child: Text(
              "投稿",
              style: TextStyle(
                  color: isCommentIn ? Colors.blue : Colors.grey
              )
          ),
          onPressed: () =>
          isCommentIn
              ? _postComment(context, widget.post)
              : null,
        ),
      ),
    );
  }

  void _onCommentChange() {
    final commentViewModel = context.read<CommentViewModel>();
    commentViewModel.comment = _commentInputTextController.text;

    setState(() {
      if (_commentInputTextController.text.length > 0) {
        isCommentIn = true;

      } else {
        isCommentIn = false;
      }
    });
  }

  _postComment(BuildContext context, Post post) async {
    final commentViewModel = context.read<CommentViewModel>();
    await commentViewModel.postComment(post);
    _commentInputTextController.clear();

  }

}
