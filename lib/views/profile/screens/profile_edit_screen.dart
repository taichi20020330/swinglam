import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swinglam/style.dart';
import 'package:swinglam/views/commons/components/circle_photo.dart';
import 'package:swinglam/views/commons/components/confirm_dialog.dart';

import '../../../view_models/profile_view_model.dart';

class ProfileEditScreen extends StatefulWidget {

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  String _photoUrl = "";
  bool _isImageFromFile = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    _isImageFromFile = false;
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;
    _nameController.text = profileUser.inAppUserName;
    _bioController.text = profileUser.bio;
    _photoUrl = profileUser.photoUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context)
          //TODO,
        ),
        actions: [
          IconButton(
            //TODO
              onPressed: () => showConfirmDialog(
                  context: context,
                  title: "プロフィールの編集",
                  content: "プロフィールを編集しますか？",
                  onConfirmed: (onConfirmed){
                    if(onConfirmed){
                      _updateProfile();
                    }
                  }),
              icon: Icon(Icons.done)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Center(
                child:
                (_photoUrl == "")
                ? Container()
                : CirclePhoto(
                  imageUrl: _photoUrl,
                  isImageFromFile: _isImageFromFile,
                  radius: 60.0,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: InkWell(
                  //TODO
                  onTap: () => _pickNewProfile(),
                  child: Text(
                    "プロフィール写真を変更",
                    style: changeProfileTextStyle,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text("Name"),
              TextField(
                controller: _nameController,
              ),
              SizedBox(height: 16.0,),
              Text("Bio"),
              TextField(
                controller: _bioController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickNewProfile() async {
    _isImageFromFile = false;
    final profileViewModel = context.read<ProfileViewModel>();
    _photoUrl = await profileViewModel.pickProfileImage();
    setState((){
      _isImageFromFile = true;
    });
  }

  _updateProfile() async {
    final profileViewModel = context.read<ProfileViewModel>();
    await profileViewModel.updateProfile(
        _nameController.text,
      _bioController.text,
      _photoUrl,
      _isImageFromFile
    );
    Navigator.pop(context);
  }
}
