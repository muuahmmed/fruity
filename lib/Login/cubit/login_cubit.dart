import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/Login/cubit/login_states.dart';
import '../../network/domain_layer/repos/auth_repo.dart';
import '../../network/local/cache helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  final AuthRepo authRepo;

  ShopLoginCubit(this.authRepo) : super(const ShopLoginInitialState());

  Future<void> userLogin({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    emit(const ShopLoginLoadingState());
    try {
      final user = await authRepo.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save authentication state
      await _saveLoginState(
        userId: user.uId,
        email: email,
        rememberMe: rememberMe,
        isGoogleSignIn: false,
      );

      emit(ShopLoginSuccessState(user: user));
    } catch (e, stackTrace) {
      emit(ShopLoginErrorState(e.toString(), stackTrace));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const ShopLoginLoadingState());
    try {
      final user = await authRepo.signInWithGoogle();

      // Save authentication state
      await _saveLoginState(
        userId: user.uId,
        email: user.email,
        rememberMe: false,
        isGoogleSignIn: true,
      );

      emit(ShopLoginSuccessState(
        user: user,
        isGoogleSignIn: true,
      ));
    } catch (e, stackTrace) {
      emit(ShopLoginErrorState(e.toString(), stackTrace));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(const ShopLoginLoadingState());
    try {
      final user = await authRepo.signInWithFacebook();

      // Save authentication state
      await _saveLoginState(
        userId: user.uId,
        email: user.email,
        rememberMe: false,
        isGoogleSignIn: false,
      );

      emit(ShopLoginSuccessState(user: user));
    } catch (e, stackTrace) {
      emit(ShopLoginErrorState(e.toString(), stackTrace));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(const ShopForgotPasswordLoadingState());
    try {
      await authRepo.sendPasswordResetEmail(email: email);
      emit(ShopForgotPasswordSuccessState(email));
    } catch (e, stackTrace) {
      emit(ShopForgotPasswordErrorState(e.toString(), stackTrace));
    }
  }

  Future<void> _saveLoginState({
    required String userId,
    required String email,
    required bool rememberMe,
    required bool isGoogleSignIn,
  }) async {
    await CacheHelper.saveData(key: 'token', value: userId);
    await CacheHelper.saveData(key: 'isGoogleSignedIn', value: isGoogleSignIn);

    if (rememberMe) {
      await CacheHelper.saveData(key: 'rememberedEmail', value: email);
    } else {
      await CacheHelper.removeData(key: 'rememberedEmail');
    }
  }
}