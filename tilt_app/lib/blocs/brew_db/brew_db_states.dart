import 'package:binary_music_tools/models/brew.dart';
import 'package:equatable/equatable.dart';

abstract class BrewDbState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class BrewDbInitialState extends BrewDbState {}

class SaveBrewLoading extends BrewDbState {}

class SaveBrewError extends BrewDbState {
  final Error error;

  SaveBrewError(this.error);

  @override
  List<Object> get props => [error];
}

class SaveBrewSuccess extends BrewDbState {}

class DeleteBrewLoading extends BrewDbState {}

class DeleteBrewError extends BrewDbState {
  final Error error;

  DeleteBrewError(this.error);

  @override
  List<Object> get props => [error];
}

class DeleteBrewSuccess extends BrewDbState {}

class GetBrewListLoading extends BrewDbState {}

class GetBrewListError extends BrewDbState {
  final Error error;

  GetBrewListError(this.error);

  @override
  List<Object> get props => [error];
}

class GetBrewListSuccess extends BrewDbState {
  final List<Brew> brews;

  GetBrewListSuccess(this.brews);

  @override
  List<Object> get props => [brews];
}
