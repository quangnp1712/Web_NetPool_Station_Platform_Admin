import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:web_netpool_station_platform_admin/core/utils/debug_logger.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.1_Authentication/model/authentication_response_model.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.2_Login/model/login_model.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.2_Login/repository/login_repository.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.2_Login/shared_preferences/login_shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String _email = "";
  LoginBloc() : super(LoginState()) {
    on<LoginInitialEvent>(_loginInitialEvent);
    on<SubmitLoginEvent>(_submitLoginEvent);
  }

  FutureOr<void> _loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) {
    _email = "";
    if (LoginPref.getEmail().toString() != "") {
      _email = LoginPref.getEmail().toString();
    } else {
      emit(state.copyWith(blocState: LoginBlocState.Initial));
    }
    if (_email != "") {
      emit(state.copyWith(email: _email));
    }
  }

  FutureOr<void> _submitLoginEvent(
      SubmitLoginEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      LoginModel loginModel =
          LoginModel(email: event.email, password: event.password);
      var results = await LoginRepository().login(loginModel);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      const List<int> errorStatuses = [404, 401];
      if (responseSuccess) {
        AuthenticationModelResponse authenticationModelResponse =
            AuthenticationModelResponse.fromJson(responseBody);
        if (authenticationModelResponse.data != null) {
          AuthenticationPref.setRoleCode(
              authenticationModelResponse.data?.roleCode ?? "");

          AuthenticationPref.setAccountID(
              authenticationModelResponse.data?.accountId as int);
          AuthenticationPref.setAccessToken(
              authenticationModelResponse.data?.accessToken.toString() ?? "");
          AuthenticationPref.setAccessExpiredAt(
              authenticationModelResponse.data?.accessExpiredAt.toString() ??
                  "");
          AuthenticationPref.setPassword(event.password.toString());
          AuthenticationPref.setUsername(
              authenticationModelResponse.data?.username.toString() ?? "");
          // AuthenticationPref.setAvatarUrl(
          //     authenticationModelResponse.data?.avatarUrl.toString() ?? "");
        }
        emit(state.copyWith(
          blocState: LoginBlocState.LoginSuccessState,
          status: LoginStatus.success,
          message: "Đăng nhập thành công",
        ));
        DebugLogger.printLog("$responseStatus - $responseMessage - thành công");
      }
      // errorStatuses = [404, 401];
      else if (errorStatuses.contains(responseStatus)) {
        DebugLogger.printLog("$responseStatus - $responseMessage");
        emit(state.copyWith(
          status: LoginStatus.failure,
          message: "Email hoặc mật khẩu không đúng",
        ));
      }
      // 403
      else if (responseStatus == 403) {
        emit(state.copyWith(
          status: LoginStatus.failure,
          message: "Chưa xác thực email",
        ));
        DebugLogger.printLog("Chưa xác thực email");
      } else {
        DebugLogger.printLog("$responseStatus - $responseMessage");
        emit(state.copyWith(
          status: LoginStatus.failure,
          message: "Lỗi! Vui lòng thử lại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        message: "Lỗi! Vui lòng thử lại",
      ));
      DebugLogger.printLog(e.toString());
    }
  }
}
