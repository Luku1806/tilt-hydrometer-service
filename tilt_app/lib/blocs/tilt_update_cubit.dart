import 'package:binary_music_tools/apis/tilt_repository.dart';
import 'package:binary_music_tools/blocs/signin_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TiltUpdateCubit extends Cubit<TiltUpdateState> {
  final TiltRepository tiltRepository;
  final SigninCubit signinCubit;

  TiltUpdateCubit({
    required this.tiltRepository,
    required this.signinCubit,
  }) : super(TiltUpdateInitialState());

  Future<void> update({double? startingGravity}) async {
    emit(TiltUpdateLoadingState());

    final stateSubscription = signinCubit.stream.skipWhile((state) {
      return state is! SigninCubitError && state is! SigninCubitSignedIn;
    }).first;

    signinCubit.signin();
    final finalState = await stateSubscription;

    if (finalState is SigninCubitSignedIn) {
      emit(TiltUpdateSuccessState());
    } else {
      emit(TiltUpdateErrorState());
    }
  }
}

abstract class TiltUpdateState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class TiltUpdateInitialState extends TiltUpdateState {}

class TiltUpdateLoadingState extends TiltUpdateState {}

class TiltUpdateErrorState extends TiltUpdateState {}

class TiltUpdateSuccessState extends TiltUpdateState {}
