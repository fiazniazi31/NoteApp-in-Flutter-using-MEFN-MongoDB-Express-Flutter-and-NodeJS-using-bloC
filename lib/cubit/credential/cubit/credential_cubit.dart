import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app_mongo_db/models/UserModel.dart';
import 'package:note_app_mongo_db/repositery/network_reposetiry.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final networkRepository = NetworkRepository();
  CredentialCubit() : super(CredentialInitial());

  Future<void> signUp(UserModel user) async {
    emit(CredentialLoading());
    try {
      final userData = await networkRepository.singUp(user);
      emit(CredentialSuccess(userData));
    } on ServerException catch (e) {
      emit(CredentialFailure(e.errorMag));
    }
  }

  Future<void> signIn(UserModel user) async {
    emit(CredentialLoading());
    try {
      final userData = await networkRepository.singIn(user);
      emit(CredentialSuccess(userData));
    } on ServerException catch (e) {
      emit(CredentialFailure(e.errorMag));
    }
  }
}
