part of 'space_list_bloc.dart';

sealed class SpaceListEvent {
  const SpaceListEvent();
}

class SpaceListInitialEvent extends SpaceListEvent {}

class CreateSpaceEvent extends SpaceListEvent {
  final SpaceModel space;
  CreateSpaceEvent(this.space);
}

class UpdateSpaceEvent extends SpaceListEvent {
  final int spaceId;
  final SpaceModel space;
  UpdateSpaceEvent(this.spaceId, this.space);
}

class DeleteSpaceEvent extends SpaceListEvent {
  final int spaceId;
  DeleteSpaceEvent(this.spaceId);
}

class ChangeSpaceStatusEvent extends SpaceListEvent {
  final int spaceId;
  final String newStatusCode;
  ChangeSpaceStatusEvent(this.spaceId, this.newStatusCode);
}
