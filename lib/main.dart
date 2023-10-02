import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app_mongo_db/cubit/auth/cubit/auth_cubit.dart';
import 'package:note_app_mongo_db/cubit/credential/cubit/credential_cubit.dart';
import 'package:note_app_mongo_db/cubit/note/cubit/note_cubit.dart';
import 'package:note_app_mongo_db/cubit/user/cubit/user_cubit.dart';
import 'package:note_app_mongo_db/router/on_generate_routs.dart';
import 'package:note_app_mongo_db/ui/home_page.dart';
import 'package:note_app_mongo_db/ui/sign_in.dart';
//import 'package:note_app_mongo_db/ui/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()..appStarted()),
        BlocProvider<CredentialCubit>(create: (_) => CredentialCubit()),
        BlocProvider<UserCubit>(create: (_) => UserCubit()),
        BlocProvider<NoteCubit>(create: (_) => NoteCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: OnGenerateRoute.route,
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authanticated) {
                if (authState.uid == "") {
                  return SignInPage();
                } else {
                  return HomePage(uid: authState.uid);
                }
              } else {
                return SignInPage();
              }
            });
          }
        },
        // home: SignUpPage()
      ),
    );
  }
}
