// Menu route render main body
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_netpool_station_platform_admin/core/router/routes.dart';
import 'package:web_netpool_station_platform_admin/feature/2_Account_Admin_Management/2.1_Account_Admin_List/bloc/admin_list_bloc.dart';
import 'package:web_netpool_station_platform_admin/feature/2_Account_Admin_Management/2.1_Account_Admin_List/pages/admin_list_page.dart';
import 'package:web_netpool_station_platform_admin/feature/2_Account_Admin_Management/2.2_Account_Admin_Create/bloc/admin_create_bloc.dart';
import 'package:web_netpool_station_platform_admin/feature/2_Account_Admin_Management/2.2_Account_Admin_Create/pages/admin_create_page.dart';
import 'package:web_netpool_station_platform_admin/feature/3_Station_Management/3.1_Station_Approval_List/bloc/station_approval_list_bloc.dart';
import 'package:web_netpool_station_platform_admin/feature/3_Station_Management/3.1_Station_Approval_List/pages/station_approval_list_page.dart';
import 'package:web_netpool_station_platform_admin/feature/3_Station_Management/3.3_Station_List/bloc/station_list_bloc.dart';
import 'package:web_netpool_station_platform_admin/feature/3_Station_Management/3.3_Station_List/pages/station_list_page.dart';

import 'package:web_netpool_station_platform_admin/feature/Dashboard/dashboard.dart';

PageRoute getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

Route<dynamic> menuRoute(RouteSettings settings) {
  final AdminListBloc adminListBloc = AdminListBloc();
  final AdminCreateBloc adminCreateBloc = AdminCreateBloc();
  final StationListBloc stationListBloc = StationListBloc();
  final StationApprovalListBloc stationApprovalListBloc =
      StationApprovalListBloc();

  switch (settings.name) {
    //! 0. DASHBOARD $//
    case dashboardPageRoute:
      return getPageRoute(const DashboardPage());

    //! 2. QUẢN LÝ STATION $//
    case stationListPageRoute:
      return MaterialPageRoute(
        builder: (context) {
          return BlocProvider<StationListBloc>.value(
            value: stationListBloc,
            child: const StationListPage(),
          );
        },
      );
    case stationApprovalListPageRoute:
      return MaterialPageRoute(
        builder: (context) {
          return BlocProvider<StationApprovalListBloc>.value(
            value: stationApprovalListBloc,
            child: const StationApprovalListPage(),
          );
        },
      );

    //! 1. QUẢN LÝ FLATFORM ADMIN $//
    case adminListPageRoute:
      return MaterialPageRoute(
        builder: (context) {
          // 'context' ở đây là context của localNavigator,
          // nó có thể tìm thấy BLoC đã được cung cấp ở main.dart
          return BlocProvider<AdminListBloc>.value(
            // Lấy BLoC instance đã tồn tại
            value: adminListBloc,
            // Cung cấp nó cho trang con
            child: const AdminListPage(),
          );
        },
      );
    case adminCreatePageRoute:
      return MaterialPageRoute(
        builder: (context) {
          // 'context' ở đây là context của localNavigator,
          // nó có thể tìm thấy BLoC đã được cung cấp ở main.dart
          return BlocProvider<AdminCreateBloc>.value(
            // Lấy BLoC instance đã tồn tại
            value: adminCreateBloc,
            // Cung cấp nó cho trang con
            child: const AdminCreatePage(),
          );
        },
      );

    //! TEST $//
    // case testRoute:
    //   return getPageRoute(const TestPage());

    default:
      return getPageRoute(const DashboardPage());
  }
}
