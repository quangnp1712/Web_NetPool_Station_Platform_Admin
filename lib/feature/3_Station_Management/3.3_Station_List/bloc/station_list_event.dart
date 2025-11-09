part of 'station_list_bloc.dart';

sealed class StationListEvent extends Equatable {
  const StationListEvent();

  @override
  List<Object> get props => [];
}

class StationListInitialEvent extends StationListEvent {}

class StationListLoadEvent extends StationListEvent {
  String? search;
  String? province;
  String? commune;
  String? district;
  String? distance;
  String? statusCodes;
  String? current;
  StationListLoadEvent({
    this.search,
    this.province,
    this.commune,
    this.district,
    this.distance,
    this.statusCodes,
    this.current,
  });
}

class RoleEvent extends StationListEvent {}
