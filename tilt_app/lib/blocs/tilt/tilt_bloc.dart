import 'package:binary_music_tools/apis/tilt_repository.dart';
import 'package:binary_music_tools/blocs/tilt/tilt_events.dart';
import 'package:binary_music_tools/blocs/tilt/tilt_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TiltBloc extends Bloc<TiltEvent, TiltState> {
  final TiltRepository _tiltRepository;

  TiltBloc({TiltRepository? tiltRepository})
      : _tiltRepository = tiltRepository ?? TiltRepository(),
        super(TiltInitialState());

  @override
  Stream<TiltState> mapEventToState(TiltEvent event) async* {
    if (event is GetTilts) {
      yield TiltListLoadingState();
      try {
        yield TiltListSuccessState(
          await _tiltRepository.findByAdapterId(
            adapterId: event.adapterId,
            idToken: event.idToken,
          ),
        );
      } catch (e) {
        print(e);
        yield TiltListErrorState();
      }
    }
  }
}
