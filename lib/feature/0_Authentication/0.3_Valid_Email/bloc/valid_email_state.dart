// ignore_for_file: constant_identifier_names

part of 'valid_email_bloc.dart';

//$ status
enum ValidEmailStatus {
  initial,
  loading,
  success,
  failure,
}

//$ blocState
enum ValidEmailBlocState {
  Initial,
  ShowRegisterState,
  ValidEmailSuccessState,
}

//$ ValidEmailState
class ValidEmailState extends Equatable {
  final String? email;
  final String message;

  final ValidEmailBlocState blocState;
  final ValidEmailStatus status;

  const ValidEmailState({
    this.email,
    this.message = '',
    this.blocState = ValidEmailBlocState.Initial,
    this.status = ValidEmailStatus.initial,
  });

  ValidEmailState copyWith({
    ValidEmailBlocState? blocState,
    ValidEmailStatus? status,
    String? email,
    String? message,
  }) {
    return ValidEmailState(
      blocState: blocState ?? ValidEmailBlocState.Initial,
      status: status ?? ValidEmailStatus.initial,
      email: email ?? this.email,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        blocState,
        status,
        message,
        email,
      ];
}
