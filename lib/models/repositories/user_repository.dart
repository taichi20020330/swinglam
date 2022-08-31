import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:swinglam/constants.dart';
import 'package:uuid/uuid.dart';

import '../../data_models/user.dart';
import '../db/databese_manager.dart';

class UserRepository {
  DatabaseManager dbManager;
  UserRepository({required this.dbManager});
  static User? currentUser;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignIn() async {
     final firebaseUser = _auth.currentUser;
     if(firebaseUser != null){
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid) ;
       return true;
     }
     return false;
  }

  Future<bool> signIn() async {
    try{
      GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      if(signInAccount == null) return false;
      GoogleSignInAuthentication signInAuthentication = await signInAccount.authentication;

      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if(firebaseUser == null){
        return false;
      }

      final isExistedInDb = await dbManager.searchUserInDb(firebaseUser);
      if(!isExistedInDb) {
        await dbManager.insertUser(_convertUser(firebaseUser));
        currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      }
    }catch(error){
      return false;
    }
    return true;
  }

  _convertUser(auth.User firebaseUser) {
    return User(
      userId: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? "",
      inAppUserName: firebaseUser.displayName ?? "",
      photoUrl: firebaseUser.photoURL ?? "",
      email: firebaseUser.email ?? "",
      bio: "",
    );
  }

  Future<User> getPostUserInfo(String userId) async {
    return await dbManager.getUserInfoFromDbById(userId);
  }

  Future<int> getNumberOfFollowers(User profileUser) async {
    return (await dbManager.getUserIdsByFollowers(profileUser.userId)).length;
  }

  Future<int> getNumberOfFollowings(User profileUser) async {
    return (await dbManager.getUserIdsByFollowings(profileUser.userId)).length;
  }

  Future<void> updateProfile(
      User profileUser,
      String name,
      String bio,
      String photoUrl,
      bool isImageFromFile
      ) async {
    var updatePhotoUrl;
    if(isImageFromFile){
      final updatePhotoFile = File(photoUrl);
      final storagePath = Uuid().v1();
      updatePhotoUrl = await dbManager.uploadImageToStorage(
          updatePhotoFile, storagePath
      );
    }
    final userBeforeUpdated = await dbManager.getUserInfoFromDbById(profileUser.userId);
    final updatedUser = userBeforeUpdated.copyWith(
      inAppUserName: name,
      bio: bio,
      photoUrl: photoUrl,
    );

    await dbManager.updateProfile(updatedUser);
  }

  Future<void> getCurrentUserById(String userId) async {
    currentUser = await dbManager.getUserInfoFromDbById(userId);
  }

  Future<List<User>> searchUsers(String query) async {
    return await dbManager.searchUsers(query);
  }

  Future<void> follow(User profileUser) async {
    await dbManager.follow(profileUser, currentUser!);
  }
  Future<void> unFollow(User profileUser) async {
    await dbManager.unFollow(profileUser, currentUser!);
  }

  Future<bool> checkIsFollowing(User profileUser) async {
    return (currentUser != null ) ? await dbManager.checkIsFollowing(profileUser, currentUser!) : false;
  }

  Future<List<User>> getUsersByCare(String id, mode) async {
    var results = <User>[];

    switch(mode){
      case WhoCareMode.LIKE:
        final postId = id;
        results = await dbManager.getUsersWhoLike(postId);
        break;
      case WhoCareMode.FOLLOW:
        final userId = id;
        results = await dbManager.getFollowerUsers(userId);
        break;
      case WhoCareMode.FOLLOWINGS:
        final userId = id;
        results = await dbManager.getFollowingUsers(userId);
        break;
    }
    return results;

  }

}