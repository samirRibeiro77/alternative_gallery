import 'package:alternative_gallery/model/user_model.dart';
import 'package:alternative_gallery/resource/string_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordDialog {
  Future<Null> build(BuildContext context, UserModel model, bool creating) {
    var title = creating
        ? StringResource.instance.passwordDialogCreating
        : StringResource.instance.passwordDialogChecking;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              onSubmitted: (text) {
                if (creating) {
                  model.createPassword(text);
                }
                else {
                  model.checkPassword(text);
                }

                Navigator.of(context).pop();
              },
              decoration: InputDecoration.collapsed(
                  hintText: StringResource.instance.passwordDialogHint,
                  border: UnderlineInputBorder()
              ),
            ),
          );
        });
  }
}