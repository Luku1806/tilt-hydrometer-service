import 'package:binary_music_tools/apis/brew_db_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class BrewDbBloc extends Bloc<BrewDbEvent, BrewDbState> {
  BrewDbProvider _brewDbProvider;

  BrewDbBloc({BrewDbProvider brewDbProvider})
      : _brewDbProvider = brewDbProvider ?? BrewDbProvider(),
        super(BrewDbInitialState());

  @override
  BrewDbState get initialState => BrewDbInitialState();

  @override
  Stream<BrewDbState> mapEventToState(BrewDbEvent event) async* {
    if (event is SaveBrew) {
      yield SaveBrewLoading();
      try {
        await _brewDbProvider.createBrew(event.brew);
        yield SaveBrewSuccess();
      } catch (error) {
        yield SaveBrewError(error);
      }
    } else if (event is DeleteBrew) {
      yield DeleteBrewLoading();
      try {
        await _brewDbProvider.deleteBrew(event.brewId);
        yield DeleteBrewSuccess();
      } catch (error) {
        yield DeleteBrewError(error);
      }
    } else if (event is GetBrewList) {
      yield GetBrewListLoading();
      try {
        var brews = await _brewDbProvider.getAllBrews();
        yield GetBrewListSuccess(brews);
      } catch (error) {
        yield GetBrewListError(error);
      }
    }
  }
}
