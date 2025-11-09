// ignore_for_file: public_member_api_docs, sort_constructors_first, camel_case_types
part of 'admin_list_bloc.dart';

sealed class AdminListState extends Equatable {
  const AdminListState();

  @override
  List<Object> get props => [];
}

final class AdminListInitial extends AdminListState {}

abstract class AdminListActionState extends AdminListState {}

class AdminList_ChangeState extends AdminListActionState {}

class AdminList_LoadingState extends AdminListState {
  final bool isLoading;

  const AdminList_LoadingState({required this.isLoading});
}

class AdminListSuccessState extends AdminListState {
  List<AdminListModel> adminList;
  List<String> statusNames;
  AdminListMetaModel meta;
  String roleName;
  AdminListSuccessState({
    required this.adminList,
    required this.statusNames,
    required this.meta,
    required this.roleName,
  });
}

class AdminListEmptyState extends AdminListState {}

class ShowSnackBarActionState extends AdminListActionState {
  final String message;
  final bool success;

  ShowSnackBarActionState({required this.success, required this.message});
}

class ShowAdminCreatePageState extends AdminListActionState {}
