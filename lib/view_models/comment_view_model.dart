import 'package:flutter/material.dart';
import 'package:swinglam/data_models/post.dart';

import '../data_models/comment.dart';
import '../data_models/user.dart';
import '../models/repositories/post_repository.dart';
import '../models/repositories/user_repository.dart';

class CommentViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final PostRepository postRepository;
  bool isProcessing = false;

  List<Comment> comments = [];

  String comment = "";

  User get currentUser => UserRepository.currentUser!;

  CommentViewModel({required this.userRepository, required this.postRepository});

  Future<void> postComment(Post post) async {
    isProcessing = true;
    notifyListeners();


    await postRepository.postComment(post, currentUser, comment);

    isProcessing = false;
    notifyListeners();
  }

  Future<void> getComments(String postId) async {
    isProcessing = true;
    notifyListeners();

    comments = await postRepository.getComments(postId);

    isProcessing = false;
    notifyListeners();
  }

  Future<User>getUserInfoByComment(String commentUserId) async {
    return await userRepository.getPostUserInfo(commentUserId);
}

  Future<void> deleteComment(Post post, int commentIndex) async {
    final deleteCommentId = comments[commentIndex].commentId;
    await postRepository.deleteComment(deleteCommentId);
    getComments(post.postId);
    notifyListeners();
  }




}