part of 'station_approval_bloc.dart';

sealed class StationApprovalState extends Equatable {
  const StationApprovalState();
  
  @override
  List<Object> get props => [];
}

final class StationApprovalInitial extends StationApprovalState {}
