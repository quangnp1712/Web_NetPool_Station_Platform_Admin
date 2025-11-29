import 'package:http/http.dart' as http;
import 'package:web_netpool_station_platform_admin/core/network/exceptions/app_exceptions.dart';
import 'package:web_netpool_station_platform_admin/core/network/exceptions/exception_handlers.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:web_netpool_station_platform_admin/feature/6_Space_Management/6.1_Space_List/api/space_list_api.dart';
import 'package:web_netpool_station_platform_admin/feature/6_Space_Management/6.1_Space_List/model/space_list_model.dart';

abstract class ISpaceListRepository {
  Future<Map<String, dynamic>> getSpaceList();
  Future<Map<String, dynamic>> updateSpace(SpaceModel spacemodel);
  Future<Map<String, dynamic>> changeStatusSpace(String spaceId, String status);
  Future<Map<String, dynamic>> deleteSpace(String spaceId);
  Future<Map<String, dynamic>> createSpace(SpaceModel spacemodel);
}

class SpaceListRepository extends SpaceListApi implements ISpaceListRepository {
  @override
  Future<Map<String, dynamic>> getSpaceList() async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(viewSpaceUrl);
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

  @override
  Future<Map<String, dynamic>> updateSpace(SpaceModel spaceModel) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$updateSpaceUrl/${spaceModel.spaceId}");
      final client = http.Client();
      final response = await client
          .put(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $jwtToken',
            },
            body: spaceModel.toJson(),
          )
          .timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  @override
  Future<Map<String, dynamic>> createSpace(SpaceModel spaceModel) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(updateSpaceUrl);
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
            body: spaceModel.toJson(),
          )
          .timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  @override
  Future<Map<String, dynamic>> changeStatusSpace(
      String spaceId, String status) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$updateSpaceUrl/$spaceId/$status");

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

  @override
  Future<Map<String, dynamic>> deleteSpace(String spaceId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$updateSpaceUrl/$spaceId");

      final client = http.Client();
      final response = await client.delete(
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
}
