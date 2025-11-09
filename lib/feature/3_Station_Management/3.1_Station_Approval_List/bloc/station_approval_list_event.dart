// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'station_approval_list_bloc.dart';

sealed class StationApprovalListEvent extends Equatable {
  const StationApprovalListEvent();

  @override
  List<Object> get props => [];
}

class StationApprovalListInitialEvent extends StationApprovalListEvent {}

class StationApprovalListLoadEvent extends StationApprovalListEvent {
  String? search;
  String? province;
  String? commune;
  String? district;
  String? distance;
  String? statusCodes;
  String? current;
  StationApprovalListLoadEvent({
    this.search,
    this.province,
    this.commune,
    this.district,
    this.distance,
    this.statusCodes,
    this.current,
  });
}

class AcceptEvent extends StationApprovalListEvent {
  int stationId;
  AcceptEvent({
    required this.stationId,
  });
}

class RejectEvent extends StationApprovalListEvent {
  int stationId;
  String rejectReason;
  RejectEvent({
    required this.stationId,
    required this.rejectReason,
  });
}

class RoleEvent extends StationApprovalListEvent {}
