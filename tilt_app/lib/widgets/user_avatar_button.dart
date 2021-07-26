import 'package:binary_music_tools/blocs/signin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAvatarButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? avatarUrl;

  UserAvatarButton({this.onPressed, this.avatarUrl});

  @override
  Widget build(context) {
    return BlocBuilder<SigninCubit, SigninCubitState>(
      builder: (blocContext, state) {
        return state is SigninCubitSignedIn
            ? IconButton(
                icon: ClipOval(child: Image.network(state.account.photoUrl!)),
                onPressed: onPressed,
              )
            : IconButton(
                icon: ClipOval(child: Icon(Icons.person)),
                onPressed: null,
              );
      },
    );
  }
}
