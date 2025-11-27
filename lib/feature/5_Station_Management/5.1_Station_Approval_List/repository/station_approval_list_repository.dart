import 'package:http/http.dart' as http;
import 'package:web_netpool_station_platform_admin/core/network/exceptions/app_exceptions.dart';
import 'package:web_netpool_station_platform_admin/core/network/exceptions/exception_handlers.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.1_Station_Approval_List/api/station_approval_list_api.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.1_Station_Approval_List/model/station_approval/station_approval_model.dart';

abstract class IStationApprovalListRepository {
  Future<Map<String, dynamic>> ApprovalWithSearch(
    String? search,
    String? province,
    String? commune,
    String? district,
    String? distance,
    String? statusCodes,
    String? current,
    String? pageSize,
  );
  Future<Map<String, dynamic>> acceptStation(int stationId);
  Future<Map<String, dynamic>> rejectStation(
      int stationId, StationApprovalModel stationApprovalModel);
}

class StationApprovalListRepository extends StationApprovalListApi
    implements IStationApprovalListRepository {
  @override
  Future<Map<String, dynamic>> ApprovalWithSearch(
    String? search,
    String? province,
    String? commune,
    String? district,
    String? distance,
    String? statusCodes,
    String? current,
    String? pageSize,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$stationApprovalListUrl?search=$search&province=$province&commune=$commune&district=$district&distance=$distance&statusCodes=$statusCodes&current=$current&pageSize=$pageSize");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  Future<Map<String, dynamic>> acceptStation(int stationId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$stationApprovalActionUrl/$stationId/accept");
      final client = http.Client();
      final response = await client.patch(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  Future<Map<String, dynamic>> rejectStation(
      int stationId, StationApprovalModel stationApprovalModel) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$stationApprovalActionUrl/$stationId/reject");
      final client = http.Client();
      final response = await client
          .patch(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $jwtToken',
            },
            body: stationApprovalModel.toJson(),
          )
          .timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }
}
