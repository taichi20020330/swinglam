import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/constants.dart';

import '../../../view_models/post_view_model.dart';
import '../components/post_caption_part.dart';

class PostUploadScreen extends StatelessWidget {
  final UploadType uploadType;

  PostUploadScreen({required this.uploadType});

  @override
  Widget build(BuildContext context) {
    final postViewModel = context.read<PostViewModel>();
    if(!postViewModel.isImagePicked  && !postViewModel.isProcessing){
      Future(() => postViewModel.pickImage(uploadType));
    }

    return Consumer<PostViewModel>(
        builder: (context, model, child){
          return Scaffold(
            appBar: AppBar(
              leading: model.isProcessing
              ? Container()
              : IconButton(
                  onPressed: () => _cancelPost(context),
                  icon: Icon(Icons.arrow_back)
              ),
              title: postViewModel.isProcessing
              ? Text("処理中...")
              : Text("投稿完了"),
              actions: <Widget>[
                (model.isProcessing || !model.isImagePicked )
                ? IconButton(
                    onPressed: () => _cancelPost(context),
                    icon: Icon(Icons.cancel)
                )
              : IconButton(
                    onPressed: null,
                    icon: Icon(Icons.done)
                )
              ],
            ),
            body: model.isProcessing
            ? Center(
              child: CircularProgressIndicator(),
            )
                : model.isImagePicked
            ? Container()
            : Column(
              children: [
                Divider(),
                PostCaptionPart(from: uploadOpenMode.FROM_POST),
                Divider(),
                // PostLocationPart(),
                Divider(),
              ],
            ),
          );
        }
    );
  }

  void _cancelPost(BuildContext context) {
    Navigator.pop(context);
  }
}
