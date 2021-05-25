import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninCubit extends Cubit<GoogleSignInAccount?> {
  final GoogleSignIn _googleSignIn;

  SigninCubit()
      : this._googleSignIn = GoogleSignIn(scopes: ["email"]),
        super(null);

  Future<void> signin() async => emit(await _googleSignIn.signIn());
}
