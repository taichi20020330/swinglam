import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/view_models/post_view_model.dart';

class PostCaptionInputTextField extends StatefulWidget {
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
    );
  }

  _onCaptionUpdated(){
    final viewModel = context.read<PostViewModel>();
    viewModel.caption = _captionController.text;
  }
}
