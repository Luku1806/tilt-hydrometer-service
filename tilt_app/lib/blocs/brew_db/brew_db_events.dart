import 'package:binary_music_tools/models/brew.dart';
import 'package:equatable/equatable.dart';

abstract class BrewDbEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SaveBrew extends BrewDbEvent {
  final Brew brew;

  SaveBrew(this.brew);

  @override
  List<Object> get props => [brew];
}

class DeleteBrew extends BrewDbEvent {
  final int brewId;

  DeleteBrew(this.brewId);

  @override
  List<Object> get props => [brewId];
}

class GetBrewList extends BrewDbEvent {
}
