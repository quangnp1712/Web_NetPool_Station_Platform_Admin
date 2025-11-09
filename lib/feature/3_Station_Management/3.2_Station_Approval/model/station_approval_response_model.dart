// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:web_netpool_station_platform_admin/core/model/base_response_model.dart';
import 'package:web_netpool_station_platform_admin/feature/3_Station_Management/3.2_Station_Approval/model/station_approval_model.dart';

class StationApprovalModelResponse extends BaseResponse {
  List<StationApprovalModel>? data;
  StationApprovalMetaModel? meta;

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
      'data': data?.map((x) => x.toMap()).toList(),
      'status': status,
      'success': success,
      'errorCode': errorCode,
      'responseAt': responseAt,
      'message': message,
    };
  }

  factory StationApprovalModelResponse.fromMap(Map<String, dynamic> map) {
    return StationApprovalModelResponse(
      data: map['data'] != null
          ? List<StationApprovalModel>.from(
              (map['data'] as List).map(
                (x) => StationApprovalModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      success: map['success'] != null ? map['success'] as bool : null,
      errorCode: map['errorCode'] as dynamic,
      responseAt:
          map['responseAt'] != null ? map['responseAt'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationApprovalModelResponse.fromJson(Map<String, dynamic> source) =>
      StationApprovalModelResponse.fromMap(source);
}

class StationApprovalMetaModel {
  int? pageSize;
  int? current;
  int? total;
  StationApprovalMetaModel({
    this.pageSize,
    this.current,
    this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pageSize': pageSize,
      'current': current,
      'total': total,
    };
  }

  factory StationApprovalMetaModel.fromMap(Map<String, dynamic> map) {
    return StationApprovalMetaModel(
      pageSize: map['pageSize'] != null ? map['pageSize'] as int : null,
      current: map['current'] != null ? map['current'] as int : null,
      total: map['total'] != null ? map['total'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationApprovalMetaModel.fromJson(Map<String, dynamic> source) =>
      StationApprovalMetaModel.fromMap(source);
}
