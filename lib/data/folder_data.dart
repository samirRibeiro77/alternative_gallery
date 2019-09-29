import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

class FolderData {
  String _id, _name;
  ListQueue _users, _images;

  FolderData(this._name) {
    _users = ListQueue();
    _images = ListQueue();
  }

  FolderData.fromDoc(DocumentSnapshot doc) {
    this._id = doc.documentID;
    this._name = doc.data["name"];
    this._users = ListQueue.of(doc.data["users"]);
    this._images = ListQueue.of(doc.data["images"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": _name,
      "users": _users,
      "images": _images,
    };
  }

  ListQueue get images => _images;
  ListQueue get users => _users;
  String get name => _name;
  String get id => _id;
}