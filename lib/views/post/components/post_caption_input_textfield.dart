import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/style.dart';
import 'package:swinglam/view_models/feed_view_model.dart';
import 'package:swinglam/view_models/post_view_model.dart';

class PostCaptionInputTextField extends StatefulWidget {
  final String? captionBeforeEdited;
  final uploadOpenMode? uploadMode;

  PostCaptionInputTextField({this.captionBeforeEdited, this.uploadMode});

  @override
  State<PostCaptionInputTextField> createState() => _PostCaptionInputTextFieldState();
}

class _PostCaptionInputTextFieldState extends State<PostCaptionInputTextField> {
  final _captionController = TextEditingController();

  @override
  void initState() {
    _captionController.addListener(() {
      _onCaptionUpdated();
    });
    if(widget.uploadMode == uploadOpenMode.FROM_FEED){
      _captionController.text = widget.captionBeforeEdited ?? "";
    }
    super.initState();
  }
  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: _captionController,
      style: postCaptionTextStyle,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "キャプションを入力...",
            border: InputBorder.none
      ),
    );
  }

  _onCaptionUpdated(){
    if(widget.uploadMode == uploadOpenMode.FROM_FEED){
      final viewModel = context.read<FeedViewModel>();
      viewModel.caption = _captionController.text;
    }else {
      final viewModel = context.read<PostViewModel>();
      viewModel.caption = _captionController.text;
    }

  }
}
