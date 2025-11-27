import 'package:http/http.dart' as http;
import 'package:web_netpool_station_platform_admin/core/network/exceptions/app_exceptions.dart';
import 'package:web_netpool_station_platform_admin/core/network/exceptions/exception_handlers.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.2_Station_Approval/api/station_approval_api.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.2_Station_Approval/model/station_approval_model.dart';

abstract class IStationApprovalRepository {
  Future<Map<String, dynamic>> createStation(
      StationApprovalModel stationApprovalModel);
}

class StationApprovalRepository extends StationApprovalApi
    implements IStationApprovalRepository {
  @override
  Future<Map<String, dynamic>> createStation(
      StationApprovalModel stationApprovalModel) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();
      Uri uri = Uri.parse(StationApprovalUrl);
      final client = http.Client();
      final response = await client
          .post(
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
