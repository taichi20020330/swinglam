import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/data_models/location.dart';
import 'package:swinglam/di/providers.dart';
import 'package:swinglam/view_models/post_view_model.dart';
import 'package:swinglam/views/post/screens/map_screen.dart';

import '../../../style.dart';

class PostLocationPart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostViewModel>();

    return ListTile(
      title: Text(
          viewModel.locationString,
        style: postLocationTextStyle,
      ),
      leading: _latLngPart(viewModel.location, context),
      trailing: IconButton(
        icon: FaIcon(FontAwesomeIcons.map),
        onPressed: () => _openMapScreen(context, viewModel.location),
      ),
    );
  }

  _latLngPart(Location? location, BuildContext context) {
    const spaceWidth = 8.0;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Chip(
          label:Text("緯度"),
        ),
        SizedBox(width: spaceWidth),
        Text(
          (location != null)
          ? location.latitude.toStringAsFixed(2)
          : ""
        ),
        SizedBox(width: spaceWidth),
        Chip(
          label:Text("経度"),
        ),
        SizedBox(width: spaceWidth),
        Text(
            (location != null)
                ? location.longitude.toStringAsFixed(2)
                : ""
        ),
      ],
    );
  }

  _openMapScreen(BuildContext context, Location? location) {
    if(location == null) return;

    Navigator.push(context, MaterialPageRoute(
        builder: (_) => MapScreen(location: location)
    ));
  }
}
