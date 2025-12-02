import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:web_netpool_station_platform_admin/core/router/routes.dart';
import 'package:web_netpool_station_platform_admin/core/utils/debug_logger.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.2_Login/shared_preferences/login_shared_preferences.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.3_Valid_Email/model/verify_email_model.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.3_Valid_Email/repository/verify_email_repository.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.3_Valid_Email/shared_preferences/verify_email_shared_preferences.dart';

part 'valid_email_event.dart';
part 'valid_email_state.dart';

class ValidEmailBloc extends Bloc<ValidEmailEvent, ValidEmailState> {
  String _email = "";

  ValidEmailBloc() : super(ValidEmailState()) {
    on<ValidEmailInitialEvent>(_validEmailInitialEvent);
    on<SendValidCodeEvent>(_sendValidEmailEvent);
    on<SubmitValidEmailEvent>(_submitValidEmailEvent);
    on<ShowVerifyEmailEvent>(_showVerifyEmailEvent);
  }

  FutureOr<void> _validEmailInitialEvent(
      ValidEmailInitialEvent event, Emitter<ValidEmailState> emit) {
    if (VerifyEmailPref.getEmail().toString() != "") {
      _email = VerifyEmailPref.getEmail().toString();
    } else {
      emit(state.copyWith(blocState: ValidEmailBlocState.Initial));
    }
    if (_email != "") {
      emit(state.copyWith(email: _email));

      add(SendValidCodeEvent(email: _email));
    } else {
      emit(state.copyWith(blocState: ValidEmailBlocState.Initial));
    }
  }

  FutureOr<void> _showVerifyEmailEvent(
      ShowVerifyEmailEvent event, Emitter<ValidEmailState> emit) {
    VerifyEmailPref.setEmail(event.email.toString());

    Get.toNamed(validEmailPageRoute);
  }

  FutureOr<void> _sendValidEmailEvent(
      SendValidCodeEvent event, Emitter<ValidEmailState> emit) async {
    emit(state.copyWith(
      blocState: ValidEmailBlocState.Initial,
      email: _email,
      status: ValidEmailStatus.loading,
    ));

    try {
      VerfyEmailModel validEmailModel = VerfyEmailModel(
        email: event.email,
      );

      var results =
          await VerifyEmailRepository().SendVerifyCode(validEmailModel);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess || responseStatus == 200) {
        emit(state.copyWith(
          status: ValidEmailStatus.success,
          message: "OTP đã được gửi đến Email $_email",
        ));

        DebugLogger.printLog("$responseStatus - $responseMessage - thanh cong");
      } else if (responseStatus == 404) {
        emit(state.copyWith(
          status: ValidEmailStatus.failure,
          message: "Email $_email chưa đăng ký",
        ));
        DebugLogger.printLog("$responseStatus - $responseMessage");
      } else if (responseStatus == 401) {
        emit(state.copyWith(
          status: ValidEmailStatus.failure,
          message: "Lỗi! Vui lòng thử lại",
        ));
        DebugLogger.printLog("$responseStatus - $responseMessage");
      } else {
        emit(state.copyWith(
          status: ValidEmailStatus.failure,
          message: "Lỗi! Vui lòng thử lại",
        ));
        DebugLogger.printLog("$responseStatus - $responseMessage");
      }
    } catch (e) {
      emit(state.copyWith(
        status: ValidEmailStatus.failure,
        message: "Lỗi! Vui lòng thử lại",
      ));
      DebugLogger.printLog(e.toString());
    }
  }

  FutureOr<void> _submitValidEmailEvent(
      SubmitValidEmailEvent event, Emitter<ValidEmailState> emit) async {
    emit(state.copyWith(
      status: ValidEmailStatus.loading,
    ));

    try {
      VerfyEmailModel validEmailModel = VerfyEmailModel(
        verificationCode: event.verificationCode,
      );

      var results = await VerifyEmailRepository().VerifyEmail(validEmailModel);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess || responseStatus == 200) {
        DebugLogger.printLog("$responseStatus - $responseMessage - thanh cong");
        LoginPref.setEmail(_email);
        emit(state.copyWith(
          status: ValidEmailStatus.success,
          message: "Email: $_email xác thực thành công !",
        ));
        Get.offAllNamed(loginPageRoute);
      } else if (responseStatus == 404) {
        emit(state.copyWith(
          status: ValidEmailStatus.failure,
          message: "Mã OTP không đúng",
        ));
        DebugLogger.printLog("$responseStatus - $responseMessage");
      } else if (responseStatus == 401) {
        emit(state.copyWith(
          status: ValidEmailStatus.failure,
          message: "Mã OTP không đúng",
        ));
        DebugLogger.printLog("$responseStatus - $responseMessage");
      } else {
        emit(state.copyWith(
          status: ValidEmailStatus.failure,
          message: "Lỗi! Vui lòng thử lại",
        ));
        DebugLogger.printLog("$responseStatus - $responseMessage");
      }
    } catch (e) {
      emit(state.copyWith(
        status: ValidEmailStatus.failure,
        message: "Lỗi! Vui lòng thử lại",
      ));
      DebugLogger.printLog(e.toString());
    }
  }
}
