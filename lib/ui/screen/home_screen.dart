import 'package:alternative_gallery/controller/home_controller.dart';
import 'package:alternative_gallery/model/user_model.dart';
import 'package:alternative_gallery/resource/string_resource.dart';
import 'package:alternative_gallery/ui/widget/password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringResource.instance.appName),
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!model.isLoggedin) {
          return Center(
            child: GestureDetector(
              onTap: () async {
                await model.login();
                if (model.isLoggedin) {
                  var dialog = PasswordDialog();
                  dialog.build(context, model, true);
                }
              },
              child: Icon(
                Icons.security,
                size: 200.0,
              ),
            ),
          );
        }

        if (!model.passwordChecked) {
          return Center(
            child: GestureDetector(
              onTap: () async {
                if (model.isLoggedin) {
                  var dialog = PasswordDialog();
                  dialog.build(context, model, false);
                }
              },
              child: Icon(
                Icons.security,
                size: 200.0,
              ),
            ),
          );
        }

        return HomeController().buildScreen(model.user.id);
      }),
      floatingActionButton: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return Visibility(
                visible: model.isLoggedin && model.passwordChecked,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.folder_special),
                )
            );
          }
      ),
    );
  }
}
