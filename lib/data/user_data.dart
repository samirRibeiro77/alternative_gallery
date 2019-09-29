import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserData {
  String _id, _name, _email, _photo, _password;

  UserData(FirebaseUser fUser, GoogleSignInAccount gUser) {
    this._id = fUser.uid;
    this._name = gUser.displayName;
    this._email = gUser.email;
    this._photo = gUser.photoUrl;
  }

  UserData.fromDoc(DocumentSnapshot doc) {
    this._id = doc.documentID;
    this._name = doc.data["name"];
    this._email = doc.data["email"];
    this._photo = doc.data["photo"];
    this._password = doc.data["password"];
  }

  Map<String, dynamic> toMap() {
    var bytes = utf8.encode(this._password);
    var cryptoPassword = sha256.convert(bytes);

    return {
      "name": _name,
      "email": _email,
      "photo": _photo,
      "password": cryptoPassword.toString(),
    };
  }

  String get photo => _photo;
  String get email => _email;
  String get name => _name;
  String get id => _id;
}