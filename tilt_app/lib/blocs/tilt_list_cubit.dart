import 'package:binary_music_tools/apis/tilt_repository.dart';
import 'package:binary_music_tools/blocs/signin_cubit.dart';
import 'package:binary_music_tools/models/tilt.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TiltListCubit extends Cubit<TiltListState> {
  final TiltRepository tiltRepository;
  final SigninCubit signinCubit;

  TiltListCubit({
    required this.tiltRepository,
    required this.signinCubit,
  }) : super(TiltListInitialState());

  Future<void> load() async {
    emit(TiltListLoadingState());

    final signinState = signinCubit.state;
    if (signinState is! SigninCubitSignedIn) {
      emit(TiltListErrorState());
      return;
    }

    try {
      final authentication = await signinState.account.authentication;
      emit(
        TiltListSuccessState(
          await tiltRepository.findAll(idToken: authentication.idToken!),
        ),
      );
    } catch (e) {
      print(e);
      emit(TiltListErrorState());
    }
  }
}

abstract class TiltListState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class TiltListInitialState extends TiltListState {}

class TiltListLoadingState extends TiltListState {}

class TiltListErrorState extends TiltListState {}

class TiltListSuccessState extends TiltListState {
  final List<Tilt> tilts;

  TiltListSuccessState(this.tilts);

  @override
  List<Object> get props => [tilts];
}
