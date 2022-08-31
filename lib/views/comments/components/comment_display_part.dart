import 'package:flutter/material.dart';
import 'package:swinglam/functinos.dart';
import 'package:swinglam/style.dart';
import 'package:swinglam/views/commons/components/circle_photo.dart';
import 'package:swinglam/views/commons/components/comment_rich_text.dart';

class CommentDisplayPart extends StatelessWidget {
  final String postUserPhotoUrl;
  final String title;
  final String content;
  final DateTime postDateTime;
  final GestureLongPressCallback? onLongPressed;

  CommentDisplayPart({required this.postUserPhotoUrl, required this.title, required this.content, required this.postDateTime, this.onLongPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onLongPress: onLongPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CirclePhoto(
                imageUrl: postUserPhotoUrl,
                isImageFromFile: false),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentRichText(title: title, content: content),
                  Text(createTimeAgoString(postDateTime), style: timeAgoTextStyle,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
