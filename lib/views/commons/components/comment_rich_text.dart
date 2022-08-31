import 'package:flutter/material.dart';

import '../../../style.dart';

class CommentRichText extends StatefulWidget {
  final String title;
  final String content;

  CommentRichText({required this.title, required this.content});

  @override
  State<CommentRichText> createState() => _CommentRichTextState();
}

class _CommentRichTextState extends State<CommentRichText> {
  int _maxLines = 2;
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        setState((){
          _maxLines = 100;
        });
      },
      child: RichText(
        maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                  text: widget.title,
                  style: commentTitleTextStyle
              ),TextSpan(
                  text: " ",
                  style: commentTitleTextStyle
              ),
              TextSpan(
                  text: widget.content,
                  style: commentContentTextStyle
              ),
            ]
          )),
    );
  }
}
