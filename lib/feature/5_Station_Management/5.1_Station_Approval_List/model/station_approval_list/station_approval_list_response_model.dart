// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:web_netpool_station_platform_admin/core/model/base_response_model.dart';
import 'package:web_netpool_station_platform_admin/feature/5_Station_Management/5.1_Station_Approval_List/model/station_approval_list/station_approval_list_model.dart';

class StationApprovalListModelResponse extends BaseResponse {
  List<StationApprovalListModel>? data;
  StationApprovalListMetaModel? meta;

  StationApprovalListModelResponse({
    this.data,
    this.meta,
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

  factory StationApprovalListModelResponse.fromMap(Map<String, dynamic> map) {
    return StationApprovalListModelResponse(
      data: map['data'] != null
          ? List<StationApprovalListModel>.from(
              (map['data'] as List).map(
                (x) =>
                    StationApprovalListModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      meta: map['meta'] != null
          ? StationApprovalListMetaModel.fromMap(
              map['meta'] as Map<String, dynamic>)
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

  factory StationApprovalListModelResponse.fromJson(
          Map<String, dynamic> source) =>
      StationApprovalListModelResponse.fromMap(source);
}

class StationApprovalListMetaModel {
  int? pageSize;
  int? current;
  int? total;
  StationApprovalListMetaModel({
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

  factory StationApprovalListMetaModel.fromMap(Map<String, dynamic> map) {
    return StationApprovalListMetaModel(
      pageSize: map['pageSize'] != null ? map['pageSize'] as int : null,
      current: map['current'] != null ? map['current'] as int : null,
      total: map['total'] != null ? map['total'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationApprovalListMetaModel.fromJson(Map<String, dynamic> source) =>
      StationApprovalListMetaModel.fromMap(source);
}
