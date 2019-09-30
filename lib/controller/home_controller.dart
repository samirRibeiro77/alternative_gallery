import 'package:alternative_gallery/resource/string_resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeController {

  Widget buildScreen(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("gallery")
          .where("users", arrayContains: userId).snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator(),);
          default:
            return _contentList(snapshot.data);
        }
      },
    );
  }

  Widget _contentList(QuerySnapshot snapshot) {
    if (snapshot.documentChanges.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.clear, size: 150.0,),
          Text(
            StringResource.instance.withoutGalleries,
            style: TextStyle(fontSize: 30.0),
          )
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.all(20.0),
      children: snapshot.documentChanges.map((doc) {
        return Card(child: Text(doc.document.documentID));
      }).toList(),
    );
  }
}