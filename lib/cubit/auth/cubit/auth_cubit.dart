import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app_mongo_db/utils/shared_pref.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final sharedPref = SharedPref();

  Future<void> appStarted() async {
    try {
      final uid = await sharedPref.getUid();
      if (uid != null) {
        emit(Authanticated(uid));
      } else {
        emit(unAuthanticated());
      }
    } catch (e) {
      emit(unAuthanticated());
    }
  }

  Future<void> loggedIn(String uid) async {
    sharedPref.setUid(uid);
    emit(Authanticated(uid));
  }

  Future<void> loggedOut() async {
    sharedPref.setUid("");
    emit(unAuthanticated());
  }
}
