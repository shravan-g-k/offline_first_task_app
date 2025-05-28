part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSignUp extends AuthState {}

final class AuthUserLoggedIn extends AuthState {
  final UserModel user;

  AuthUserLoggedIn({required this.user});
}

final class AuthError extends AuthState {
  final String error;

  AuthError({required this. error});
}
