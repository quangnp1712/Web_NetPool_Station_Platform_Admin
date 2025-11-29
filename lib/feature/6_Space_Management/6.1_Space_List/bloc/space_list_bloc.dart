import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_netpool_station_platform_admin/core/utils/debug_logger.dart';
import 'package:web_netpool_station_platform_admin/feature/6_Space_Management/6.1_Space_List/model/space_list_model.dart';
import 'package:web_netpool_station_platform_admin/feature/6_Space_Management/6.1_Space_List/model/space_list_response_model.dart';
import 'package:web_netpool_station_platform_admin/feature/6_Space_Management/6.1_Space_List/repository/space_list_repository.dart';

part 'space_list_event.dart';
part 'space_list_state.dart';

class SpaceListBloc extends Bloc<SpaceListEvent, SpaceListState> {
  SpaceListBloc() : super(SpaceListState()) {
    on<SpaceListInitialEvent>(_onInit);
    on<CreateSpaceEvent>(_onCreate);
    on<UpdateSpaceEvent>(_onUpdate);
    on<DeleteSpaceEvent>(_onDelete);
    on<ChangeSpaceStatusEvent>(_onChangeStatus);
  }

  Future<void> _onInit(
      SpaceListInitialEvent event, Emitter<SpaceListState> emit) async {
    emit(state.copyWith(status: SpaceStatus.loading));
    try {
      var results = await SpaceListRepository().getSpaceList();
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        SpaceListModelResponse spaceListModelResponse =
            SpaceListModelResponse.fromJson(responseBody);
        List<SpaceModel> _spaceList = [];
        if (spaceListModelResponse.data != null) {
          _spaceList = spaceListModelResponse.data!;
          for (var space in _spaceList) {
            // api chua co feild color va icon
            if (space.metadata?.icon == null || space.metadata?.icon == "") {
              space.metadata?.icon = space.typeCode;
            }
            // ------------
          }
          emit(state.copyWith(spaces: _spaceList));
        }
      } else {
        emit(state.copyWith(
            status: SpaceStatus.failure,
            message: "Lỗi: $responseMessage",
            spaces: []));
      }
    } catch (e) {
      emit(state.copyWith(
          status: SpaceStatus.failure,
          message: "Lỗi tải dữ liệu: $e",
          spaces: []));
    }
  }

  Future<void> _onCreate(
      CreateSpaceEvent event, Emitter<SpaceListState> emit) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      SpaceMetaDataModel metadata = SpaceMetaDataModel(
        bgColor: event.space.metadata?.bgColor,
        icon: event.space.metadata?.icon,
      );

      SpaceModel spaceModel = SpaceModel(
          spaceId: event.space.spaceId,
          typeCode: event.space.typeCode,
          typeName: event.space.typeName,
          statusCode: "ACTIVE",
          metadata: metadata);

      var results = await SpaceListRepository().createSpace(spaceModel);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        SpaceListModelResponse spaceListModelResponse =
            SpaceListModelResponse.fromJson(responseBody);
        emit(state.copyWith(
          status: SpaceStatus.success,
          message: "Tạo loại hình thành công!",
          isActionLoading: false,
        ));
        add(SpaceListInitialEvent());
      } else if (responseStatus == 409) {
        emit(state.copyWith(
            status: SpaceStatus.failure,
            message: responseMessage,
            isActionLoading: false));
        DebugLogger.printLog(responseMessage);
      } else if (responseStatus == 500) {
        emit(state.copyWith(
            status: SpaceStatus.failure,
            message: "Lỗi Server",
            isActionLoading: false));
        DebugLogger.printLog(responseMessage);
      } else {
        emit(state.copyWith(
            status: SpaceStatus.failure,
            message: "Tạo thất bại",
            isActionLoading: false));
        DebugLogger.printLog(responseMessage);
      }
    } catch (e) {
      emit(state.copyWith(
          status: SpaceStatus.failure,
          message: "Tạo thất bại: $e",
          isActionLoading: false));
      DebugLogger.printLog("Tạo thất bại: $e");
    }
  }

  Future<void> _onUpdate(
      UpdateSpaceEvent event, Emitter<SpaceListState> emit) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      SpaceMetaDataModel metadata = SpaceMetaDataModel(
        bgColor: event.space.metadata?.bgColor,
        icon: event.space.metadata?.icon,
      );
      SpaceModel spaceModel = SpaceModel(
        spaceId: event.space.spaceId,
        typeCode: event.space.typeCode,
        typeName: event.space.typeName,
        metadata: metadata,
      );
      var results = await SpaceListRepository().updateSpace(spaceModel);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        SpaceListModelResponse spaceListModelResponse =
            SpaceListModelResponse.fromJson(responseBody);
        List<SpaceModel> _spaceList = [];

        emit(state.copyWith(
          blocState: SpaceListBlocState.UpdateSpaceSucessState,
          status: SpaceStatus.success,
          message: "Cập nhật thành công!",
          isActionLoading: false,
        ));
      } else if (responseStatus == 500) {
        emit(
            state.copyWith(status: SpaceStatus.failure, message: "Lỗi Server"));
      } else {
        emit(state.copyWith(
            status: SpaceStatus.failure, message: "Lỗi: $responseMessage"));
      }
    } catch (e) {
      emit(state.copyWith(
          status: SpaceStatus.failure,
          message: "Cập nhật thất bại: $e",
          isActionLoading: false));
    }
  }

  Future<void> _onDelete(
      DeleteSpaceEvent event, Emitter<SpaceListState> emit) async {
    try {
      var results =
          await SpaceListRepository().deleteSpace(event.spaceId.toString());
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        final newSpaces = List<SpaceModel>.from(state.spaces)
          ..removeWhere((s) => s.spaceId == event.spaceId);

        emit(state.copyWith(
          status: SpaceStatus.success,
          message: "Đã xóa loại hình",
          spaces: newSpaces,
        ));
      } else if (responseStatus == 500) {
        emit(
            state.copyWith(status: SpaceStatus.failure, message: "Lỗi Server"));
      } else {
        emit(state.copyWith(
            status: SpaceStatus.failure, message: "Xóa thất bại"));
      }
    } catch (e) {
      // Nếu lỗi thì revert (load lại init)
      add(SpaceListInitialEvent());
      emit(
          state.copyWith(status: SpaceStatus.failure, message: "Xóa thất bại"));
    }
  }

  Future<void> _onChangeStatus(
      ChangeSpaceStatusEvent event, Emitter<SpaceListState> emit) async {
    // Gọi API
    try {
      String status = event.newStatusCode == "ACTIVE" ? "enable" : "disable";

      var results = await SpaceListRepository()
          .changeStatusSpace(event.spaceId.toString(), status);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        final newSpaces = state.spaces.map((s) {
          if (s.spaceId == event.spaceId) {
            return s.copyWith(
                statusCode: event.newStatusCode,
                statusName: event.newStatusCode == "ACTIVE"
                    ? "Đang hoạt động"
                    : "Ngừng hoạt động");
          }
          return s;
        }).toList();
        emit(state.copyWith(
            status: SpaceStatus.success,
            message: "Đổi trạng thái thành công",
            spaces: newSpaces));
      } else if (responseStatus == 500) {
        emit(
            state.copyWith(status: SpaceStatus.failure, message: "Lỗi Server"));
      } else {
        emit(state.copyWith(
            status: SpaceStatus.failure, message: "Đổi trạng thái thất bại"));
      }
    } catch (e) {
      // Revert nếu lỗi
      emit(state.copyWith(
          status: SpaceStatus.failure, message: "Đổi trạng thái thất bại"));

      add(SpaceListInitialEvent());
    }
  }

  final Random _random = Random();

  String _getRandomCaptchaColor() {
    return _presetColors[_random.nextInt(_presetColors.length)];
  }

  final List<String> _presetColors = [
    "#CB30E0",
    "#2EBD59",
    "#00C6FF",
    "#FF9800",
    "#F44336",
    "#E91E63",
    "#9C27B0",
    "#3F51B5",
    "#FFC107",
    "#009688",
    "#795548",
  ];
}
