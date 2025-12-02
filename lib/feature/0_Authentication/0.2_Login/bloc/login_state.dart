// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: camel_case_types, constant_identifier_names

part of 'login_bloc.dart';

// status
enum LoginStatus {
  initial,
  loading,
  success,
  failure,
}

// blocState
enum LoginBlocState {
  Initial,
  LoginSuccessState,
}

class LoginState extends Equatable {
  final String? email;
  final String message;

  final LoginBlocState blocState;
  final LoginStatus status;

  const LoginState({
    this.email,
    this.message = '',
    this.blocState = LoginBlocState.Initial,
    this.status = LoginStatus.initial,
  });

  LoginState copyWith({
    LoginBlocState? blocState,
    LoginStatus? status,
    String? email,
    String? message,
  }) {
    return LoginState(
      blocState: blocState ?? LoginBlocState.Initial,
      status: status ?? LoginStatus.initial,
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
