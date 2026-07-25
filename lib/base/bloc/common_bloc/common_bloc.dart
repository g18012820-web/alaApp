import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/base/extension/num_extension.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/use_case/auth/logout_use_case.dart';
import '../base_bloc/base_bloc.dart';
import 'common_event.dart';
import 'common_state.dart';

@injectable
class CommonBloc extends BaseBloc<CommonEvent, CommonState> {
  CommonBloc(this._logoutUseCase) : super(CommonState(isLoading: false, countLoading: 0)) {
    on<LoadingVisibilityEmitted>(_onLoadingVisibilityEmitted);
    on<AddExceptionCommonEvent>(_onAddExceptionCommonEvent);
    on<ForceLogoutCommonEvent>(_onForceLogoutCommonEvent);
  }

  final LogoutUseCase _logoutUseCase;

  Future<void> _onLoadingVisibilityEmitted(
    LoadingVisibilityEmitted event,
    Emitter<CommonState> emit,
  ) async {
    final newCount = event.isLoading ? state.countLoading.plus(1) : state.countLoading.minus(1);

    final newIsLoading = newCount > 0;

    emit(state.copyWith(
      isLoading: newIsLoading,
      countLoading: newCount,
    ));
  }

  FutureOr<void> _onAddExceptionCommonEvent(AddExceptionCommonEvent event, Emitter<CommonState> emit) {
    emit(state.copyWith(exception: event.exception));
  }

  FutureOr<void> _onForceLogoutCommonEvent(ForceLogoutCommonEvent event, Emitter<CommonState> emit) async {
    await _logoutUseCase.invoke(null);
    event.completer.complete();
  }
}
