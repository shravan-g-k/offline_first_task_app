import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/repository/remote_auth_repo.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final authRemoteRepository = RemoteAuthRepo();
  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      await authRemoteRepository.signUp(
        name: name,
        email: email,
        password: password,
      );

      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }
  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
       final user = await authRemoteRepository.login(
        email: email,
        password: password,
      );

      emit(AuthUserLoggedIn(user: user

      ));
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }


}
