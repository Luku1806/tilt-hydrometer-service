import 'package:binary_music_tools/blocs/tilt_list_cubit.dart';
import 'package:binary_music_tools/pages/tilt/widgets/tilt_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TiltPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TiltPageState();
}

class _TiltPageState extends State<TiltPage> {
  @override
  void didChangeDependencies() {
    fetchTilts();
    super.didChangeDependencies();
  }

  Future<void> fetchTilts() async {
    context.read<TiltListCubit>().load();
  }

  @override
  Widget build(context) {
    return RefreshIndicator(
      onRefresh: () => fetchTilts(),
      child: BlocBuilder<TiltListCubit, TiltListState>(
        builder: (context, state) {
          if (state is TiltListLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TiltListSuccessState) {
            return TiltList(tilts: state.tilts);
          } else if (state is TiltListErrorState ||
              state is TiltListInitialState) {
            return Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(child: Text("Could not load tilts")),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
