import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/view_models/post_view_model.dart';
import 'package:swinglam/views/feed/common/sub/image_from_url.dart';
import 'package:swinglam/views/post/components/post_caption_input_textfield.dart';
import 'package:swinglam/views/post/screens/enlarge_image_screen.dart';
import '../../../constants.dart';
import '../../../data_models/post.dart';
import '../pages/hero_image.dart';

class PostCaptionPart extends StatelessWidget {
  final uploadOpenMode from;
  final Post? post;
  PostCaptionPart({required this.from, this.post});

  @override
  Widget build(BuildContext context) {
    if(from == uploadOpenMode.FROM_POST){
      final postViewModel = context.read<PostViewModel>();
      final image = (postViewModel.imageFile != null)
          ? Image.file(postViewModel.imageFile!)
          : Image.network('https://picsum.photos/250?image=9');
      return ListTile(
        leading: HeroImage(
          image: image,
          onTap: () => _displayLargeImage(context, image),
        ),
        title: PostCaptionInputTextField(),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            ImageFromUrl(
                imageUrl: post?.imageUrl
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostCaptionInputTextField(
                  captionBeforeEdited: post?.caption,
                uploadMode: from
              ),
            )
          ],
        ),
      );
    }
  }

  _displayLargeImage(BuildContext context, Image image) {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => EnlargeImageScreen(image: image)
    ));
  }
}
