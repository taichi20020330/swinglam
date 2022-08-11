import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

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
}