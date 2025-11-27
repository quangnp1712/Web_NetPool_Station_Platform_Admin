import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_netpool_station_platform_admin/core/utils/debug_logger.dart';
import 'package:web_netpool_station_platform_admin/core/utils/utf8_encoding.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.1_Station_Approval_List/model/station_approval/station_approval_model.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.1_Station_Approval_List/model/station_approval/station_approval_response_model.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.1_Station_Approval_List/model/station_approval_list/station_approval_list_model.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.1_Station_Approval_List/model/station_approval_list/station_approval_list_response_model.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.1_Station_Approval_List/repository/station_approval_list_repository.dart';

part 'station_approval_list_event.dart';
part 'station_approval_list_state.dart';

class StationApprovalListBloc
    extends Bloc<StationApprovalListEvent, StationApprovalListState> {
  StationApprovalListBloc() : super(StationApprovalListInitial()) {
    on<StationApprovalListInitialEvent>(_StationApprovalListInitialEvent);
    on<StationApprovalListLoadEvent>(_StationApprovalListLoadEvent);
    on<AcceptEvent>(_acceptEvent);
    on<RejectEvent>(_rejectEvent);
  }

  FutureOr<void> _StationApprovalListInitialEvent(
      StationApprovalListInitialEvent event,
      Emitter<StationApprovalListState> emit) {
    emit(StationApprovalListInitial());
    add(StationApprovalListLoadEvent());
  }

  FutureOr<void> _StationApprovalListLoadEvent(
      StationApprovalListLoadEvent event,
      Emitter<StationApprovalListState> emit) async {
    emit(StationApprovalList_ChangeState());
    emit(StationApprovalList_LoadingState(isLoading: true));
    try {
      String? search = event.search ?? "";

      String? province = event.province ?? "";

      String? commune = event.commune ?? "";

      String? district = event.district ?? "";

      String? distance = event.distance ?? "";

      String? statusCodes = "PENDING";

      String? current = event.current ?? "";

      String? pageSize = "10";

      var results = await StationApprovalListRepository().ApprovalWithSearch(
          search,
          province,
          commune,
          district,
          distance,
          statusCodes,
          current,
          pageSize);

      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        StationApprovalListModelResponse stationApprovalListModelResponse =
            StationApprovalListModelResponse.fromJson(responseBody);
        List<StationApprovalListModel> _StationApprovalList = [];

        try {
          if (stationApprovalListModelResponse.data != null) {
            if (stationApprovalListModelResponse.data!.isNotEmpty) {
              _StationApprovalList = stationApprovalListModelResponse.data!;
              if (_StationApprovalList.isEmpty) {
                emit(StationApprovalList_ChangeState());
                emit(StationApprovalList_LoadingState(isLoading: false));
                emit(StationApprovalListEmptyState());
              } else {
                for (var _station in _StationApprovalList) {
                  _station.stationName =
                      Utf8Encoding().decode(_station.stationName.toString());
                  _station.province =
                      Utf8Encoding().decode(_station.province.toString());
                  _station.district =
                      Utf8Encoding().decode(_station.district.toString());
                  _station.statusName =
                      Utf8Encoding().decode(_station.statusName.toString());
                }
                // 1. Dùng map() để lấy tất cả statusName (bao gồm cả null và trùng lặp)
                // 2. Dùng whereType<String>() để lọc bỏ null
                // 3. Dùng toSet() để loại bỏ trùng lặp
                // 4. Dùng toApproval() để chuyển về danh sách (Approval)
                StationApprovalListMetaModel metaModel =
                    stationApprovalListModelResponse.meta!;

                try {
                  if (metaModel.current! >= 0) {
                    metaModel.current = metaModel.current! + 1;
                  }
                } catch (e) {}
                emit(StationApprovalList_ChangeState());
                emit(StationApprovalList_LoadingState(isLoading: false));
                emit(StationApprovalListSuccessState(
                    StationApprovalList: _StationApprovalList,
                    meta: metaModel));
              }
            }
          }

          if (stationApprovalListModelResponse.data!.isEmpty) {
            emit(StationApprovalList_ChangeState());
            emit(StationApprovalList_LoadingState(isLoading: false));
            emit(StationApprovalListEmptyState());
          }
        } catch (e) {
          emit(StationApprovalListEmptyState());
          DebugLogger.printLog(e.toString());
          emit(StationApprovalList_LoadingState(isLoading: false));
        }
        DebugLogger.printLog("$responseStatus - $responseMessage - thành công");
      } else {
        DebugLogger.printLog("$responseStatus - $responseMessage");

        emit(StationApprovalList_LoadingState(isLoading: false));
        emit(ShowSnackBarActionState(
            message: "Lỗi! Vui lòng thử lại", success: responseSuccess));
      }
    } catch (e) {
      emit(ShowSnackBarActionState(
          message: "Lỗi! Vui lòng thử lại", success: false));
      emit(StationApprovalList_LoadingState(isLoading: false));
      DebugLogger.printLog(e.toString());
    }
  }

  FutureOr<void> _acceptEvent(
      AcceptEvent event, Emitter<StationApprovalListState> emit) async {
    emit(StationApprovalList_ChangeState());
    emit(StationApprovalList_LoadingState(isLoading: true));
    try {
      var results =
          await StationApprovalListRepository().acceptStation(event.stationId);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        emit(StationApprovalList_LoadingState(isLoading: false));
        emit(ShowSnackBarActionState(
            message: "Chấp thuận Station thành công",
            success: responseSuccess));
        DebugLogger.printLog("$responseStatus - $responseMessage - thành công");
        add(StationApprovalListLoadEvent());
      } else {
        DebugLogger.printLog("$responseStatus - $responseMessage");

        emit(StationApprovalList_LoadingState(isLoading: false));
        emit(ShowSnackBarActionState(
            message: "Lỗi! Vui lòng thử lại", success: responseSuccess));
      }
    } catch (e) {
      emit(StationApprovalList_LoadingState(isLoading: false));
      emit(ShowSnackBarActionState(
          message: "Lỗi! Vui lòng thử lại", success: false));
      DebugLogger.printLog(e.toString());
    }
  }

  FutureOr<void> _rejectEvent(
      RejectEvent event, Emitter<StationApprovalListState> emit) async {
    emit(StationApprovalList_ChangeState());
    emit(StationApprovalList_LoadingState(isLoading: true));
    try {
      StationApprovalModel stationApprovalModel =
          StationApprovalModel(rejectReason: event.rejectReason);
      var results = await StationApprovalListRepository()
          .rejectStation(event.stationId, stationApprovalModel);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        emit(StationApprovalList_LoadingState(isLoading: false));
        emit(ShowSnackBarActionState(
            message: "Từ chối Station thành công", success: responseSuccess));
        DebugLogger.printLog("$responseStatus - $responseMessage - thành công");
        add(StationApprovalListLoadEvent());
      } else {
        DebugLogger.printLog("$responseStatus - $responseMessage");

        emit(StationApprovalList_LoadingState(isLoading: false));
        emit(ShowSnackBarActionState(
            message: "Lỗi! Vui lòng thử lại", success: responseSuccess));
      }
    } catch (e) {
      emit(StationApprovalList_LoadingState(isLoading: false));
      emit(ShowSnackBarActionState(
          message: "Lỗi! Vui lòng thử lại", success: false));
      DebugLogger.printLog(e.toString());
    }
  }
}
