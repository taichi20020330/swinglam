import 'package:flutter/material.dart';
import 'package:swinglam/constants.dart';

import '../data_models/post.dart';
import '../data_models/user.dart';
import '../models/repositories/post_repository.dart';
import '../models/repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final PostRepository postRepository;
  final UserRepository userRepository;
  bool isProcessing = false;
  late User profileUser;
  User get currentUser => UserRepository.currentUser!;
  List<Post> posts = [];
  bool isFollowing = false;

  ProfileViewModel({required this.postRepository, required this.userRepository});

  void setProfileUser(ProfileOpenMode profileMode, User? selectedUser){
    if(profileMode == ProfileOpenMode.MYSELF) {
      profileUser = currentUser;
    } else {
      profileUser = selectedUser!;
      _checkIsFollowing();
    }
  }

  Future<void> getPosts(ProfileOpenMode profileMode) async {
    isProcessing = true;
    notifyListeners();

    posts = await postRepository.getPosts(feedOpenMode.FROM_PROFILE, profileUser);

    isProcessing = false;
    notifyListeners();

  }

  Future<int> getNumberOfPosts() async {
    return (await postRepository.getPosts(feedOpenMode.FROM_PROFILE, profileUser)).length;
  }

  Future<int> getNumberOfFollowers() async {
    return await userRepository.getNumberOfFollowers(profileUser);
  }

  Future<int> getNumberOfFollowings() async {
    return await userRepository.getNumberOfFollowings(profileUser);

  }

  Future<String>pickProfileImage() async {
    final pickedImage = await postRepository.pickImage(UploadType.GALLERY);
    return (pickedImage != null) ? pickedImage.path : "";
  }

  Future<void> updateProfile(
      String name,
      String bio,
      String photoUrl,
      bool isImageFromFile
      ) async {
    isProcessing = true;
    notifyListeners();

    await userRepository.updateProfile(
        profileUser, name,bio,photoUrl,isImageFromFile
    );

    await userRepository.getCurrentUserById(currentUser.userId);
    profileUser = currentUser;

    isProcessing = false;
    notifyListeners();

  }

  Future<void> follow() async {
    await userRepository.follow(profileUser);
    isFollowing = true;
    notifyListeners();
  }

  Future<void> _checkIsFollowing() async {
    isFollowing = await userRepository.checkIsFollowing(profileUser);
    notifyListeners();
  }

  Future<void> unFollow() async {
    await userRepository.unFollow(profileUser);
    isFollowing = true;
    notifyListeners();
  }


}