part of 'station_approval_list_bloc.dart';

sealed class StationApprovalListState extends Equatable {
  const StationApprovalListState();

  @override
  List<Object> get props => [];
}

final class StationApprovalListInitial extends StationApprovalListState {}

abstract class StationApprovalListActionState
    extends StationApprovalListState {}

class StationApprovalList_ChangeState extends StationApprovalListActionState {}

class StationApprovalList_LoadingState extends StationApprovalListState {
  final bool isLoading;

  StationApprovalList_LoadingState({required this.isLoading});
}

class StationApprovalListSuccessState extends StationApprovalListState {
  List<StationApprovalListModel> StationApprovalList;
  StationApprovalListMetaModel meta;
  StationApprovalListSuccessState(
      {required this.StationApprovalList, required this.meta});
}

class StationApprovalListEmptyState extends StationApprovalListState {}

class ShowSnackBarActionState extends StationApprovalListActionState {
  final String message;
  final bool success;

  ShowSnackBarActionState({required this.success, required this.message});
}
