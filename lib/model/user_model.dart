import 'dart:convert';

import 'package:alternative_gallery/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
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

  bool isLoading = false;
  bool passwordChecked = false;

  bool get isLoggedin => _firebaseUser != null;
  
  void _startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    isLoading = false;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);
    _startLoading();
    await _loadUser();
    _finishLoading();
  }

  Future<Null> login() async {
    _startLoading();

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

    //print("User => ${_firebaseUser.uid} // ${_googleUser.displayName} // ${user.email}");

    _finishLoading();
  }

  void logout() {
    _startLoading();

    _finishLoading();
  }

  void checkPassword(String password) {
    _startLoading();

    var bytes = utf8.encode(password);
    var cryptoPassword = sha256.convert(bytes);

    passwordChecked = user.password.toLowerCase() == cryptoPassword.toString().toLowerCase();

    _finishLoading();
  }

  void createPassword(String password) async {
    _startLoading();

    user.password = password;
    await Firestore.instance.collection("users")
        .document(user.id).setData(user.toMap());

    passwordChecked = true;
    notifyListeners();

    _finishLoading();
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