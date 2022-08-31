import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swinglam/data_models/like.dart';
import 'package:swinglam/data_models/user.dart';
import 'package:swinglam/models/db/databese_manager.dart';
import 'package:swinglam/models/location/location_manager.dart';
import 'package:uuid/uuid.dart';
import '../../constants.dart';
import '../../data_models/comment.dart';
import '../../data_models/location.dart' as Local;
import '../../data_models/post.dart';

class PostRepository {
  final DatabaseManager dbManager;
  final LocationManager locationManager;
  File? imageFile;

  PostRepository({required this.dbManager, required this.locationManager});

  Future<File?> pickImage(UploadType uploadType) async {
    final ImagePicker _picker = ImagePicker();

    if(uploadType == UploadType.GALLERY){
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    } else {
      final pickedImage = await _picker.pickImage(source: ImageSource.camera);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    }

  }
  Future<Local.Location> getCurrentLocation() async {
    return await locationManager.getCurrentLocation();
  }

  Future<void> post(
      User currentUser,
      File imageFile,
      String caption,
      Local.Location? location,
      String locationString
      ) async {
    final storageId = Uuid().v1();
    final imageUrl = await dbManager.uploadImageToStorage(imageFile, storageId);
    final post = Post(
      postId: Uuid().v1(),
      userId: currentUser.userId,
      imageUrl: imageUrl,
      imageStoragePath: storageId,
      caption: caption,
      latitude: (location != null) ? location.latitude : 0.0,
      longitude: (location != null) ? location.longitude : 0.0,
      PostDateTime: DateTime.now(),
      locationString: locationString,
    );

    await dbManager.insertPost(post);

  }

  Future<List<Post>> getPosts(feedOpenMode from, User feedUser) async {
    if(from == feedOpenMode.FROM_FEED){
      return await dbManager.getPostsByMineAndFollowings(feedUser.userId);
    } else {
      return await dbManager.getPostsByUser(feedUser.userId);
    }
  }

  Future<void>updatePost(Post updatePost) async {
    return dbManager.updatePost(updatePost);
  }

  Future<void> postComment(Post post, User commentUser, String commentString) async {
    final comment = Comment(
      comment: commentString,
      commentDateTime: DateTime.now(),
      postId: post.postId,
      commentId: Uuid().v1(),
      commentUserId: commentUser.userId
    );
    await dbManager.postComment(comment);
  }

  Future<List<Comment>> getComments(String postId) async {
    return await dbManager.getComments(postId);
  }

  Future<void>deleteComment(String deleteCommentId) async {
    await dbManager.deleteComment(deleteCommentId);
  }

  Future<void> likeIt(Post post, User currentUser) async {
    final like = Like(
      likeId: Uuid().v1(),
      postId: post.postId,
      likeUserId: currentUser.userId,
      likeDateTime: DateTime.now(),
    );
    await dbManager.postLike(like);
  }

  Future<void> unLikeIt(Post post, User currentUser) async {
    await dbManager.unLikeIt(post, currentUser);
  }


  Future<LikeResult>getLikeResults(String postId, User currentUser) async {
    final likes = await dbManager.getLikeResults(postId);
    var isLikePost = false;
    for(var like in likes){
      if(like.likeUserId == currentUser.userId){
        isLikePost = true;
        break;
      }
    }
    return LikeResult(likes: likes, isLikedToThisPost: isLikePost);
  }

  Future<void> deletePost(String postId, String imageStoragePath) async {
    await dbManager.deletePost(postId, imageStoragePath);
  }

  Future<Local.Location>updateLocation(double latitude, double longitude) async {
    return await locationManager.updateLocation(latitude, longitude);
  }




}