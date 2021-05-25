import 'package:binary_music_tools/models/tilt.dart';
import 'package:equatable/equatable.dart';

abstract class TiltState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class TiltInitialState extends TiltState {}

class TiltListLoadingState extends TiltState {}

class TiltListErrorState extends TiltState {}

class TiltListSuccessState extends TiltState {
  final List<Tilt> tilts;

  TiltListSuccessState(this.tilts);

  @override
  List<Object> get props => [tilts];
}
