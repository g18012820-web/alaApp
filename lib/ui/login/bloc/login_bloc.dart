import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_template/base/bloc/base_bloc/base_bloc.dart';
import 'package:flutter_bloc_template/base/helper/duration_provider.dart';
import 'package:flutter_bloc_template/ui/login/bloc/login_event.dart';
import 'package:flutter_bloc_template/ui/login/bloc/login_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<LoginEmailChangedEvent>(_onLoginEmailChangedEvent);
    on<LoginPasswordChangedEvent>(_onLoginPasswordChangedEvent);
    onThrottle<LoginSubmittedEvent>(_onLoginSubmittedEvent, duration: const OneSecondDuration());
  }

  Future<void> _onLoginEmailChangedEvent(LoginEmailChangedEvent event, Emitter<LoginState> emit) async {}

  FutureOr<void> _onLoginPasswordChangedEvent(LoginPasswordChangedEvent event, Emitter<LoginState> emit) {}

  FutureOr<void> _onLoginSubmittedEvent(LoginSubmittedEvent event, Emitter<LoginState> emit) {
    return runAction(
      onAction: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
    );
  }
}
