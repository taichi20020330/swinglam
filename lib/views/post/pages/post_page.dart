import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/views/commons/components/buttonWithIcon.dart';
import 'package:swinglam/views/post/screens/post_upload_screen.dart';

class PostPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ButtonWithIcon(
                iconData: FontAwesomeIcons.images,
                  label: "ギャラリー",
                onPressed: () => _openPostUploadScreen(UploadType.GALLERY, context),
              ),
              SizedBox(height: 24.0),
              ButtonWithIcon(
                iconData: FontAwesomeIcons.camera,
                label: "カメラ",
                onPressed: () => _openPostUploadScreen(UploadType.CAMERA, context),
              )
            ],
          ),
        ),
      ),
    );
  }

  _openPostUploadScreen(UploadType uploadType, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => PostUploadScreen(uploadType: uploadType)
    ));

  }
}
