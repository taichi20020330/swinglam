import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/views/commons/components/confirm_dialog.dart';

import '../../../view_models/post_view_model.dart';
import '../components/post_caption_part.dart';
import '../components/post_location_part.dart';

class PostUploadScreen extends StatelessWidget {
  final UploadType uploadType;

  PostUploadScreen({required this.uploadType});

  @override
  Widget build(BuildContext context) {
    final postViewModel = context.read<PostViewModel>();
    if (!postViewModel.isImagePicked && !postViewModel.isProcessing) {
      Future(() => postViewModel.pickImage(uploadType));
    }

    return Consumer<PostViewModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          leading: model.isProcessing
              ? Container()
              : IconButton(
                  onPressed: () => _cancelPost(context),
                  icon: Icon(Icons.arrow_back)),
          title: postViewModel.isProcessing ? Text("処理中...") : Text("投稿完了"),
          actions: <Widget>[
            (model.isProcessing || !model.isImagePicked)
                ? IconButton(
                    onPressed: () => _cancelPost(context),
                    icon: Icon(Icons.cancel))
                : IconButton(
                    onPressed: () => showConfirmDialog(
                        context: context,
                        title: "投稿",
                        content: "投稿しますか？",
                        onConfirmed: (isConfirmed) {
                          if (isConfirmed) {
                            _post(context);
                          }
                        }),
                    icon: Icon(Icons.done))
          ],
        ),
        body: model.isProcessing
            ? Center(
                child: CircularProgressIndicator(),
              )
            : model.isImagePicked
                ? Column(
          children: [
            Divider(),
            PostCaptionPart(from: uploadOpenMode.FROM_POST),
            Divider(),
            PostLocationPart(),
            Divider(),
          ],
        )
            : Container()
      );
    });
  }

  void _cancelPost(BuildContext context) {
    final viewModel = context.read<PostViewModel>();
    viewModel.cancelPost();
    Navigator.pop(context);
  }

  void _post(BuildContext context) async  {
    final viewModel = context.read<PostViewModel>();
    await viewModel.post();
    Navigator.pop(context);
  }
}
