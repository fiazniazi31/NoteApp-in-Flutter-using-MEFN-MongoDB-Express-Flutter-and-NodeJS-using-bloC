import 'package:flutter/material.dart';
import 'package:note_app_mongo_db/models/NoteModel.dart';
import 'package:note_app_mongo_db/router/page_const.dart';
import 'package:note_app_mongo_db/ui/add_note_page.dart';
import 'package:note_app_mongo_db/ui/profile_Page.dart';
import 'package:note_app_mongo_db/ui/sign_in.dart';
import 'package:note_app_mongo_db/ui/sign_up.dart';
import 'package:note_app_mongo_db/ui/update_note_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageConst.signInPage:
        {
          return materialPageBuilder(widget: SignInPage());
        }
      case PageConst.signUpPage:
        {
          return materialPageBuilder(widget: SignUpPage());
        }
      case PageConst.profilePage:
        {
          if (args is String) {
            return materialPageBuilder(
                widget: ProfilePage(
              uid: args,
            ));
          } else {
            return materialPageBuilder(widget: Errorpage());
          }
        }
      case PageConst.addNotePage:
        {
          if (args is String) {
            return materialPageBuilder(
                widget: AddNotePage(
              uid: args,
            ));
          } else {
            return materialPageBuilder(widget: Errorpage());
          }
        }
      case PageConst.updateNotePage:
        {
          if (args is NoteModel) {
            return materialPageBuilder(
                widget: UpdateNotePage(
              note: args,
            ));
          } else {
            return materialPageBuilder(widget: Errorpage());
          }
        }
      default:
        return materialPageBuilder(widget: Errorpage());
    }
  }
}

class Errorpage extends StatelessWidget {
  const Errorpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
      ),
      body: Center(child: Text("Page Route Error")),
    );
  }
}

MaterialPageRoute materialPageBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}
