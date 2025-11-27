import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'station_approval_event.dart';
part 'station_approval_state.dart';

class StationApprovalBloc extends Bloc<StationApprovalEvent, StationApprovalState> {
  StationApprovalBloc() : super(StationApprovalInitial()) {
    on<StationApprovalEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
