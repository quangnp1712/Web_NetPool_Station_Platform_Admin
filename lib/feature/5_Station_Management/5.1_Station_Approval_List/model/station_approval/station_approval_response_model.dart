// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:web_netpool_station_platform_admin/core/model/base_response_model.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.1_Station_Approval_List/model/station_approval/station_approval_model.dart';

class StationApprovalModelResponse extends BaseResponse {
  StationApprovalModel? data;

  StationApprovalModelResponse({
    this.data,
    status,
    success,
    errorCode,
    responseAt,
    message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data?.toMap(),
    };
  }

  factory StationApprovalModelResponse.fromMap(Map<String, dynamic> map) {
    return StationApprovalModelResponse(
      data: map['data'] != null
          ? StationApprovalModel.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationApprovalModelResponse.fromJson(Map<String, dynamic> source) =>
      StationApprovalModelResponse.fromMap(source);
}
