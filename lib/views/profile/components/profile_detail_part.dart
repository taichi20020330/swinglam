import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/views/profile/components/profile_posts_grid_part.dart';
import 'package:swinglam/views/profile/components/sub/profile_bio.dart';
import 'package:swinglam/views/profile/components/sub/profile_image.dart';
import 'package:swinglam/views/profile/components/sub/profile_records.dart';
import '../../../constants.dart';
import '../../../view_models/profile_view_model.dart';

class ProfileDetailPart extends StatelessWidget {
  final ProfileOpenMode profileMode;

  ProfileDetailPart({required this.profileMode});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                  child: ProfileImage()
              ),
              Expanded(
                flex: 3,
                  child: ProfileRecords()
              )
            ],
          ),
          ProfileBio(profileMode: profileMode,),
        ],
      ),
    );
  }
}
