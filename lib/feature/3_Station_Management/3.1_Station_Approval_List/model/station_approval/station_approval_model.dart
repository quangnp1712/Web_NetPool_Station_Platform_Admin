import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class StationApprovalModel {
  String? rejectReason;
  StationApprovalModel({
    this.rejectReason,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rejectReason': rejectReason,
    };
  }

  factory StationApprovalModel.fromMap(Map<String, dynamic> map) {
    return StationApprovalModel(
      rejectReason:
          map['rejectReason'] != null ? map['rejectReason'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationApprovalModel.fromJson(Map<String, dynamic> source) =>
      StationApprovalModel.fromMap(source);
}
