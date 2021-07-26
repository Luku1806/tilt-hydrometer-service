import 'package:binary_music_tools/blocs/signin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(context) {
    return new Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: Text("Brewers Tools"),
        elevation: 0,
        backgroundColor: Colors.green[900],
      ),
      body: BlocConsumer<SigninCubit, SigninCubitState>(
        listener: (context, state) {
          if (state is SigninCubitError) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Failed'),
                  content: Text("Signing in failed. Please try again."),
                  actions: [
                    TextButton(
                      child: Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: state is SigninCubitLoading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SignInButton(
                        Buttons.Google,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: EdgeInsets.all(8),
                        onPressed: () => context.read<SigninCubit>().signin(),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
