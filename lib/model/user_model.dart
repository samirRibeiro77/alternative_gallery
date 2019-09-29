import 'package:alternative_gallery/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  final _auth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount _googleUser;
  UserData user;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  bool _isLoading = false;

  bool get isLoggedin => user != null;

  Future<Null> login() async {
    _isLoading = true;

    _googleUser = _googleSignIn.currentUser;
    if (_googleUser == null) _googleUser = await _googleSignIn.signInSilently();
    if (_googleUser == null) _googleUser = await _googleSignIn.signIn();

    if (await _auth.currentUser() == null) {
      var authentication = await _googleSignIn.currentUser.authentication;
      var googleCredentials = GoogleAuthProvider.getCredential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken
      );
      var authResult = await _auth.signInWithCredential(googleCredentials);
      _firebaseUser = authResult.user;
    }

    await _loadUser();
    if (user == null) {
      await _saveUser();
    }

    _isLoading = false;
  }

  void logout() {
    _isLoading = true;

    _isLoading = false;
  }

  void checkPassword(String password) {
    _isLoading = true;

    _isLoading = false;
  }

  Future<Null> _saveUser() async {
    user = UserData(_firebaseUser, _googleUser);
    await Firestore.instance.collection("users")
        .document(user.id).setData(user.toMap());
  }

  Future<Null> _loadUser() async {
    _firebaseUser = await _auth.currentUser();
    if (_firebaseUser != null) {
      var doc = await Firestore.instance.collection("users")
          .document(_firebaseUser.uid).get();

      if (doc.data == null)
        await _createUser();
      else
        user = UserData.fromDoc(doc);
    }
  }

  Future<Null> _createUser() async {
    if (_googleUser == null || _firebaseUser == null) {
      await login();
    }
    else {
      await _saveUser();
    }
  }
}