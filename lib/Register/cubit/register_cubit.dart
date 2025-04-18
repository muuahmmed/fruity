import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/cupertino.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/network/domain_layer/repos/auth_repo.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  static RegisterCubit get(BuildContext context) =>
      BlocProvider.of<RegisterCubit>(context);

  final AuthRepo authRepo;

  RegisterCubit(this.authRepo) : super(RegisterInitialState());

  Future<void> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async
  {
    emit(RegisterLoadingState());
    try {
      if (password != confirmPassword) {
        emit(RegisterErrorState('Passwords do not match'));
        return;
      }

      final userEntity = await authRepo.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      emit(RegisterSuccessState(userEntity: userEntity));
    } on FirebaseAuthException catch (e) {
      emit(RegisterErrorState(e.message ?? 'Registration failed'));
    } catch (e) {
      emit(RegisterErrorState(e.toString()));
    }
  }
}
