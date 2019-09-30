import 'package:alternative_gallery/model/user_model.dart';
import 'package:alternative_gallery/resource/string_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewGalleryDialog {
  Future<Null> build(BuildContext context, UserModel model) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(StringResource.instance.newGalleryDialogTitle),
            content: TextField(
              onSubmitted: (text) {

                Navigator.of(context).pop();
              },
              decoration: InputDecoration.collapsed(
                  hintText: StringResource.instance.newGalleryDialogHint,
                  border: UnderlineInputBorder()
              ),
            ),
          );
        });
  }
}