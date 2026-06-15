import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authService) : super(AuthInitial());

  final AuthService _authService;

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final success = await _authService.signInWithGoogle();
    if (success) {
      emit(AuthSuccess());
    } else {
      emit(AuthError('Sign in failed. Please try again.'));
    }
  }
}
