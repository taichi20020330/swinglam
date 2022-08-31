import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:swinglam/data_models/comment.dart';
import 'package:swinglam/data_models/post.dart';
import 'package:swinglam/models/repositories/user_repository.dart';

import '../../data_models/like.dart';
import '../../data_models/location.dart';
import '../../data_models/user.dart';

class DatabaseManager {
  FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<bool> searchUserInDb(auth.User firebaseUser) async {
    final query = await _db.collection('users').where("userId", isEqualTo: firebaseUser.uid).get();
    if(query.docs.length > 0){
      return true;
    } else {
      return false;
    }
  }

  Future<void> insertUser(User user) async {
    await _db.collection("users").doc(user.userId).set(user.toMap());
  }

  Future<User> getUserInfoFromDbById(String userId) async {
    final query = await _db.collection("users").where("userId", isEqualTo: userId).get();
    return User.fromMap(query.docs[0].data());
  }

  Future<String> uploadImageToStorage(File imageFile, String storageId) async  {
    final storageRef = FirebaseStorage.instance.ref().child(storageId);
    final uploadTask = storageRef.putFile(imageFile);
    return uploadTask.then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
    // return await uploadTask.snapshot.ref.getDownloadURL();
  }

  Future<void>insertPost(Post post) async {
    await _db.collection("posts").doc(post.postId).set(post.toMap());
  }

  Future<List<Post>> getPostsByMineAndFollowings(String userId) async {
    final query = await _db.collection("posts").get();
    if(query.docs.length == 0) return [];

    var userIds = await getUserIdsByFollowings(userId);
    userIds.add(userId);

    final quotient = userIds.length ~/ 10;
    final reminder = userIds.length % 10;
    final numberOfChunks = (reminder == 0) ? quotient : quotient + 1;
    var userIdChunks = <List<String>>[];

    if(quotient == 0){
      userIdChunks.add(userIds);
    } else if(quotient == 1) {
      userIdChunks.add(userIds.sublist(0, 10));
      userIdChunks.add(userIds.sublist(10, 10 + reminder));
      for(int i = 0; i < numberOfChunks -1 ; i++){
        userIdChunks.add(userIds.sublist(i * 10, i * 10 + 10));
      }
      userIdChunks.add(userIds.sublist((numberOfChunks -1) * 10 , (numberOfChunks -1) * 10 + reminder));
    }

    var results = <Post>[];
    await Future.forEach(userIdChunks, (List<String> userIds) async {
      final tempPosts = await getPostsOfChunkedUsers(userIds);
      tempPosts.forEach((post) {
        results.add(post);
      });
    });
    return results;
  }

  Future<List<String>> getUserIdsByFollowings(String userId) async {
    final query = await _db.collection("users").doc(userId).collection("followings").get();
    if(query.docs.length == 0) return [];

    var userIds = <String>[];
    query.docs.forEach((id) {
      userIds.add(id.data()["userId"]);
    });
    return userIds;

  }

  Future<List<String>> getUserIdsByFollowers(String userId) async {
    final query = await _db.collection("users").doc(userId).collection("followers").get();
    if(query.docs.length == 0) return [];

    var userIds = <String>[];
    query.docs.forEach((id) {
      userIds.add(id.data()["userId"]);
    });
    return userIds;
  }




  Future<List<Post>> getPostsOfChunkedUsers(List<String> userIds) async {
    var results = <Post>[];
    await _db.collection("posts").where("userId", whereIn: userIds)
        .orderBy("PostDateTime", descending: true)
        .get().then((value) {
      value.docs.forEach((element) {
        results.add(Post.fromMap(element.data()));
      });
    }
    );
    return results;
  }

  Future<void> updatePost(Post updatePost) async {
    final ref = _db.collection("posts").doc(updatePost.postId);
    await ref.update(updatePost.toMap());
  }

  Future<void> postComment(Comment comment) async {
    await _db.collection("comments").doc(comment.commentId).set(comment.toMap());
  }

  Future<List<Comment>> getComments(String postId) async {
    final query = await _db.collection("comments").get();
    if(query.docs.length == 0) return [];

    var results = <Comment>[];
    await _db.collection("comments")
        .where("postId", isEqualTo: postId)
        .orderBy("commentDateTime")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        results.add(Comment.fromMap(element.data()));
      });
    }
    );
    return results;
  }

  Future<void> deleteComment(String deleteCommentId) async {
    await _db.collection("comments").doc(deleteCommentId).delete();
  }

  Future<void>postLike(Like like) async {
    await _db.collection("likes").doc(like.likeId).set(like.toMap());
  }

  Future<List<Like>> getLikeResults(String postId) async {
    final query = await _db.collection("likes").get();
    if(query.docs.length == null) return [];

    var results = <Like>[];
    await _db.collection("likes").where("postId", isEqualTo: postId).orderBy("likeDateTime")
    .get().then((value) {
      value.docs.forEach((element) {
        results.add(Like.fromMap(element.data()));
      });
    });
    return results;
  }

  Future<void> unLikeIt(Post post, User currentUser) async {
    final likeRef = await _db.collection("likes")
        .where("postId", isEqualTo: post.postId)
        .where("likeUserId", isEqualTo: currentUser.userId)
        .get();
    likeRef.docs.forEach((element) async {
      final ref = _db.collection("likes").doc(element.id);
      await ref.delete();
    });
    
  }

  Future<void> deletePost (String postId, String imageStoragePath) async {
    //Post
    final postRef = _db.collection("posts").doc(postId);
    await postRef.delete();

    //Comment
    final commentRef = await _db.collection("comments").where("postId", isEqualTo: postId).get();
    commentRef.docs.forEach((element) async {
      final ref = await _db.collection("comments").doc(element.id);
      ref.delete();
    });

    //Like
    final likeRef = await _db.collection("likes").where("postId", isEqualTo: postId).get();
    likeRef.docs.forEach((element) async {
      final ref = await _db.collection("likes").doc(element.id);
      ref.delete();
    });

    //Storage
    final storageRef = FirebaseStorage.instance.ref().child(imageStoragePath);
    storageRef.delete();
  }

  Future<List<Post>> getPostsByUser (String userId) async {
    final query = await _db.collection("posts").get();
    if(query.docs.length == 0) return [];

    var results = <Post>[];
    query.docs.forEach((element) {
      results.add(Post.fromMap(element.data()));
    });
    return results;
  }


  Future<void> updateProfile(User updatedUser) async {
    final ref =_db.collection("users").doc(updatedUser.userId);
    await ref.update(updatedUser.toMap());
  }

  Future<List<User>> searchUsers(String queryString) async {
    final query = await _db.collection("users").orderBy("inAppUserName")
        .startAt([queryString])
        .endAt([queryString+ "\uf8ff"] )
        .get();
    if(query.docs.length == 0) return [];

    var soughtUsers = <User>[];
    query.docs.forEach((element) {
      final selectedUser = User.fromMap(element.data());
      if(selectedUser.userId != UserRepository.currentUser!.userId){
        soughtUsers.add(selectedUser);
      }
    });
    return soughtUsers;

  }

  Future<void>follow(User profileUser, User currentUser) async {
    //currentUserにとってのfollowings設定
    await _db.collection("users").doc(currentUser.userId)
        .collection("followings").doc(profileUser.userId)
    .set({"userId" : profileUser.userId});

    await _db.collection("users").doc(profileUser.userId)
        .collection("followers").doc(currentUser.userId)
        .set({"userId" : currentUser.userId});
  }

  Future<bool> checkIsFollowing(User profileUser, User currentUser) async {
    final query = await _db.collection("users").doc(currentUser.userId).collection("followings").get();
    if(query.docs.length == 0) return false;

    final checkQuery = await _db.collection("users")
        .doc(currentUser.userId)
        .collection("followings")
        .where("userId", isEqualTo: profileUser.userId)
        .get();

    if(checkQuery.docs.length > 0) { return true; }
    else {return false;}


  }

  Future<void> unFollow (User profileUser, User currentUser) async {
    //currentUserにとってのfollowings設定
    await _db.collection("users").doc(currentUser.userId)
        .collection("followings").doc(profileUser.userId)
        .delete();

    await _db.collection("users").doc(profileUser.userId)
        .collection("followers").doc(currentUser.userId)
        .delete();
  }

  Future<List<User>> getUsersWhoLike (String postId) async {
    final query = await _db.collection("likes").where("postId" ,isEqualTo: postId).get();
    if(query.docs.length == 0) return [];

    var userIds = <String>[];
    query.docs.forEach((id) {
      userIds.add(id.data()["likeUserId"]);
    });

    var likeUsers = <User>[];
    await Future.forEach(userIds, (String userId) async {
      final user = await getUserInfoFromDbById(userId);
      likeUsers.add(user);
    });


    return likeUsers;
  }

  Future<List<User>> getFollowerUsers(String profileUserId) async {
    final profileUserIds = await getUserIdsByFollowers(profileUserId);

    var followers = <User>[];
    await Future.forEach(profileUserIds, (String profileUserId) async {
      final user = await getUserInfoFromDbById(profileUserId);
      followers.add(user);
    });
    return followers;
  }

  Future<List<User>> getFollowingUsers(String profileUserId) async {
    final profileUserIds = await getUserIdsByFollowings(profileUserId);

    var followings = <User>[];
    await Future.forEach(profileUserIds, (String profileUserId) async {
      final user = await getUserInfoFromDbById(profileUserId);
      followings.add(user);
    });
    return followings;
  }




}