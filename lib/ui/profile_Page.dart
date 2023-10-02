import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_mongo_db/cubit/user/cubit/user_cubit.dart';
import 'package:note_app_mongo_db/models/UserModel.dart';
import 'package:note_app_mongo_db/ui/widgets/common/common.dart';
import 'package:note_app_mongo_db/ui/widgets/customButton.dart';
import 'package:note_app_mongo_db/ui/widgets/customTextField.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailControler = TextEditingController();
  TextEditingController usernameControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().myProfile(UserModel(uid: widget.uid));
  }

  @override
  void dispose() {
    emailControler.dispose();
    usernameControler.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UserLoaded) {
            _updateDetail(userState.user);

            return Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Username"),
                  SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    hint: "Username",
                    controller: usernameControler,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Email"),
                  SizedBox(
                    height: 5,
                  ),
                  AbsorbPointer(
                    child: CustomTextField(
                      hint: "Email",
                      controller: emailControler,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                    title: "Update Profile",
                    onTap: updateProfile,
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void updateProfile() {
    if (usernameControler.text.isEmpty) {
      showSnachBarMsg("Enter Username", context);
      return;
    }
    context
        .read<UserCubit>()
        .updateProfile(
            UserModel(uid: widget.uid, username: usernameControler.text))
        .then((value) {
      showSnachBarMsg("Profile Update Successfully", context);
    });
  }

  void _updateDetail(UserModel user) {
    emailControler.value = TextEditingValue(text: user.email!);
    usernameControler.value = TextEditingValue(text: user.username!);
  }
}
