import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swinglam/constants.dart';
import 'package:swinglam/models/repositories/user_repository.dart';
import '../data_models/location.dart';
import '../models/repositories/post_repository.dart';

class PostViewModel extends ChangeNotifier {
  final PostRepository postRepository;
  final UserRepository userRepository;
  bool isProcessing = false;
  bool isImagePicked = false;
  String locationString = "";
  String caption = "";

  File? imageFile;
  Location? location;

  String? file_string;

  PostViewModel({required this.postRepository, required this.userRepository});

  Future<void> pickImage(UploadType uploadType) async {
    isProcessing = true;
    isImagePicked = false;
    notifyListeners();

    imageFile = await postRepository.pickImage(uploadType);

    if(imageFile != null) isImagePicked = true;

    location = await postRepository.getCurrentLocation();
    locationString = _toLocationString(location);


    isProcessing = false;
    notifyListeners();

  }

  _toLocationString(Location? location) {
    return location!.country + " " + location.city + " " + location.state;
  }

}
