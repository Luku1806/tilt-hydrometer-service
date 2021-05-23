import 'package:binary_music_tools/blocs/brew_db/bloc.dart';
import 'package:binary_music_tools/pages/brew_list/widgets/brews_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrewListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrewDbBloc, BrewDbState>(
      builder: (BuildContext context, BrewDbState state) {
        if (state is GetBrewListSuccess) {
          return BrewsList(brews: state.brews);
        } else if (state is GetBrewListError) {
          return Center(child: Text(state.error.toString()));
        } else if (state is GetBrewListLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
