import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/style.dart';
import 'package:swinglam/views/feed/pages/sub/feed_sub_page.dart';
import 'package:swinglam/views/post/screens/post_upload_screen.dart';

class FeedPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.cameraRetro),
          onPressed:() => _launchUpload(context),
        ),
        title: Text("Swinglam",
            style: feedTitleStyle
        ),
        
      ),
      body: FeedSubPage(
          feedMode: feedOpenMode.FROM_FEED,
          index: 0,
      )
      );
  }

  _launchUpload(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => PostUploadScreen(uploadType: UploadType.CAMERA))
    );
  }
}
