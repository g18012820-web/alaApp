import '../../exception/app_exception.dart';
import '../base_bloc/base_state.dart';

class CommonState extends BaseState {
  final bool isLoading;
  final int countLoading;
  final AppException? exception;

  CommonState({
    required this.isLoading,
    required this.countLoading,
    this.exception,
  });

  CommonState copyWith({
    bool? isLoading,
    int? countLoading,
    AppException? exception,
  }) {
    return CommonState(
      isLoading: isLoading ?? this.isLoading,
      countLoading: countLoading ?? this.countLoading,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        countLoading,
        exception,
      ];
}
