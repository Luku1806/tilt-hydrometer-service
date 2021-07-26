import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninCubit extends Cubit<SigninCubitState> {
  final GoogleSignIn _googleSignIn;

  SigninCubit()
      : this._googleSignIn = GoogleSignIn(scopes: ["email"]),
        super(SigninCubitSignedOut());

  Future<void> signin() async {
    emit(SigninCubitLoading());

    try {
      final account = await _googleSignIn.signIn();

      if (account != null) {
        emit(SigninCubitSignedIn(account));
      } else {
        emit(SigninCubitError());
      }
    } catch (error) {
      emit(SigninCubitError());
      print(error);
    }
  }

  Future<void> signinSilent() async {
    emit(SigninCubitLoading());

    final account = await _googleSignIn.signInSilently(suppressErrors: true);

    if (account != null) {
      emit(SigninCubitSignedIn(account));
    } else {
      emit(SigninCubitSilentError());
    }
  }

  Future<void> signout() async {
    emit(SigninCubitLoading());
    try {
      await _googleSignIn.signOut();
      emit(SigninCubitSignedOut());
    } catch (error) {
      emit(SigninCubitError());
    }
  }
}

class SigninCubitState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SigninCubitSignedOut extends SigninCubitState {}

class SigninCubitLoading extends SigninCubitState {}

class SigninCubitError extends SigninCubitState {}

class SigninCubitSilentError extends SigninCubitState {}

class SigninCubitSignedIn extends SigninCubitState {
  final GoogleSignInAccount account;

  SigninCubitSignedIn(this.account);

  @override
  List<Object> get props => [account];
}
