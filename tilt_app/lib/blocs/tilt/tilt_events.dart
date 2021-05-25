import 'package:equatable/equatable.dart';

abstract class TiltEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class GetTilts extends TiltEvent {}
