import 'package:binary_music_tools/blocs/tilt/tilt_bloc.dart';
import 'package:binary_music_tools/blocs/tilt/tilt_events.dart';
import 'package:binary_music_tools/blocs/tilt/tilt_states.dart';
import 'package:binary_music_tools/pages/tilt/widgets/tilt_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TiltPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TiltPageState();
}

class _TiltPageState extends State<TiltPage> {
  @override
  void initState() {
    context.read<TiltBloc>().add(GetTilts());
    super.initState();
  }

  Future<void> refreshTilts() async {
    context.read<TiltBloc>().add(GetTilts());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshTilts,
      child: BlocBuilder<TiltBloc, TiltState>(
        builder: (context, state) {
          if (state is TiltListSuccessState) {
            return TiltList(tilts: state.tilts);
          } else if (state is TiltListErrorState) {
            return Center(child: Text("Could not load tilts"));
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
