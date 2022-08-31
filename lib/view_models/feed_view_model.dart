import 'package:flutter/material.dart';
import 'package:swinglam/data_models/like.dart';
import 'package:swinglam/models/repositories/post_repository.dart';
import 'package:swinglam/models/repositories/user_repository.dart';

import '../constants.dart';
import '../data_models/comment.dart';
import '../data_models/post.dart';
import '../data_models/user.dart';

class FeedViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final PostRepository postRepository;
  bool isProcessing = false;
  List<Post> posts = [];

  late User feedUser;

  String caption = "";
  User get currentUser => UserRepository.currentUser!;

  void setFeedUser(feedOpenMode from, User? user){
    if(from == feedOpenMode.FROM_FEED){
      feedUser = currentUser;
    } else {
      feedUser = user!;
    }
  }

  FeedViewModel({required this.userRepository, required this.postRepository});

  Future<void> getPosts(feedOpenMode feedMode) async {
    isProcessing = true;
    notifyListeners();

    posts = await postRepository.getPosts(feedMode, feedUser);

    isProcessing = false;
    notifyListeners();

  }


  Future<User> getPostUserInfo(String userId) async {
    return await userRepository.getPostUserInfo(userId);
  }

  Future<void> updatePost(Post post, feedOpenMode feedMode) async {
    isProcessing = true;
    notifyListeners();

    await postRepository.updatePost(post.copyWith(caption: caption));
    await getPosts(feedMode);

    isProcessing = false;
    notifyListeners();
  }

  Future<List<Comment>> getComments(String postId) async {
    return await postRepository.getComments(postId);
  }

  Future<void>likeIt(Post post) async {
    await postRepository.likeIt(post, currentUser);
    notifyListeners();
  }

  Future<void>unLikeIt(Post post) async {
    await postRepository.unLikeIt(post, currentUser);
    notifyListeners();
  }


  Future<LikeResult> getLikeResults(String postId) async {
    return await postRepository.getLikeResults(postId, currentUser);
  }

  void deletePost(Post post, feedOpenMode feedMode) async {
    isProcessing = true;
    notifyListeners();

    await postRepository.deletePost(post.postId, post.imageStoragePath);
    await getPosts(feedMode);

    isProcessing = false;
    notifyListeners();

  }


}