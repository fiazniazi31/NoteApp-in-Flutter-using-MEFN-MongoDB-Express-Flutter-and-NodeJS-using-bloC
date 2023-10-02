part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class Authanticated extends AuthState {
  final uid;

  Authanticated(this.uid);

  @override
  List<Object> get props => [uid];
}

final class unAuthanticated extends AuthState {
  @override
  List<Object> get props => [];
}
