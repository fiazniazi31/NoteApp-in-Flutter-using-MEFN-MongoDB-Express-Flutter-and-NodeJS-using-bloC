import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_mongo_db/cubit/auth/cubit/auth_cubit.dart';
import 'package:note_app_mongo_db/cubit/credential/cubit/credential_cubit.dart';
import 'package:note_app_mongo_db/models/UserModel.dart';
import 'package:note_app_mongo_db/router/page_const.dart';
import 'package:note_app_mongo_db/ui/home_page.dart';
import 'package:note_app_mongo_db/ui/widgets/common/common.dart';
import 'package:note_app_mongo_db/ui/widgets/customButton.dart';
import 'package:note_app_mongo_db/ui/widgets/customTextField.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailControler = TextEditingController();
  TextEditingController usernameControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

  @override
  void dispose() {
    emailControler.dispose();
    passwordControler.dispose();
    usernameControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            context.read<AuthCubit>().loggedIn(credentialState.usre.uid!);
          }
          if (credentialState is CredentialFailure) {
            showSnachBarMsg(credentialState.errorMsg, context);
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authanticated) {
                return HomePage(uid: authState.uid);
              } else {
                return _bodyWidget();
              }
            });
          }
          return _bodyWidget();
        },
      ),
    );
  }

  Widget _bodyWidget() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sing Up"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Note App",
                  style: TextStyle(fontSize: 50),
                ),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                hint: "Username",
                controller: usernameControler,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Email",
                controller: emailControler,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Password",
                controller: passwordControler,
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                title: "Sign Up",
                onTap: _submitSignUp,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("If have an accout "),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, PageConst.signInPage, (route) => false);
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitSignUp() {
    if (usernameControler.text.isEmpty) {
      showSnachBarMsg("Entter Username", context);
      return;
    }
    if (emailControler.text.isEmpty) {
      showSnachBarMsg("Entter Email", context);
      return;
    }
    if (passwordControler.text.isEmpty) {
      showSnachBarMsg("Enter Password", context);
      return;
    }
    context.read<CredentialCubit>().signUp(UserModel(
          username: usernameControler.text,
          email: emailControler.text,
          password: passwordControler.text,
        ));
  }
}
