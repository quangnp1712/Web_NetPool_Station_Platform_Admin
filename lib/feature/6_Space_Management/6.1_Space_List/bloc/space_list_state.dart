// ignore_for_file: constant_identifier_names

part of 'space_list_bloc.dart';

// status
enum SpaceStatus { initial, loading, success, failure }

enum ScreenMode { create, view, edit }

// blocState
enum SpaceListBlocState {
  initial,
  UpdateSpaceSucessState,
  UpdateSpaceFailState,
}

class SpaceListState extends Equatable {
  final SpaceStatus status;
  final ScreenMode screenMode;
  final SpaceListBlocState blocState;
  final String message;
  final List<SpaceModel> spaces;

  // Loading cục bộ cho hành động nhỏ (đổi status, delete)
  final bool isActionLoading;

  const SpaceListState({
    this.status = SpaceStatus.initial,
    this.screenMode = ScreenMode.view,
    this.blocState = SpaceListBlocState.initial,
    this.message = '',
    this.spaces = const [],
    this.isActionLoading = false,
  });

  SpaceListState copyWith({
    SpaceStatus? status,
    SpaceListBlocState? blocState,
    ScreenMode? screenMode,
    String? message,
    List<SpaceModel>? spaces,
    bool? isActionLoading,
  }) {
    return SpaceListState(
      status: status ?? SpaceStatus.initial, // Reset status mặc định
      blocState:
          blocState ?? SpaceListBlocState.initial, // Reset status mặc định
      screenMode: screenMode ?? ScreenMode.view, // Reset status mặc định
      message: message ?? this.message,
      spaces: spaces ?? this.spaces,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        blocState,
        screenMode,
        message,
        spaces,
        isActionLoading,
      ];
}
