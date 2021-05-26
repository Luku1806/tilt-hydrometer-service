import 'package:binary_music_tools/blocs/signin_cubit.dart';
import 'package:binary_music_tools/blocs/tilt/bloc.dart';
import 'package:binary_music_tools/pages/tilt/widgets/tilt_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TiltPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TiltPageState();
}

class _TiltPageState extends State<TiltPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchTilts(GoogleSignInAccount? account) async {
    if (account == null) {
      context.read<SigninCubit>().signin();
      return;
    }

    final idToken = (await account.authentication).idToken!;

    context.read<TiltBloc>().add(GetTilts(
      adapterId: "simple-test",
      idToken: idToken,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final account = context.select<SigninCubit, GoogleSignInAccount?>(
          (signInCubit) => signInCubit.state,
    );

    return RefreshIndicator(
      onRefresh: () => fetchTilts(account),
      child: BlocBuilder<TiltBloc, TiltState>(
        builder: (context, state) {
          if (state is TiltListSuccessState) {
            return TiltList(tilts: state.tilts);
          } else if (state is TiltListErrorState || state is TiltInitialState) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: Center(child: Text("Could not load tilts")),
              ),
            );
          } else if (state is TiltListLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
