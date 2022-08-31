import 'package:flutter/material.dart';
import 'package:swinglam/views/commons/components/circle_photo.dart';

class UserCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;
  final String title;
  final String subTitle;
  final Widget? trailing;

  UserCard({
    required this.imageUrl,
    this.onTap,
    required this.title,
    required this.subTitle,
    this.trailing
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blueGrey,
      onTap: onTap,
      child: ListTile(
       leading: CirclePhoto(
         imageUrl: imageUrl,
         isImageFromFile: false,
       ),
        title: Text(title),
        subtitle: Text(subTitle),
        trailing: trailing,
      ),
    );
  }
}
