import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SpaceModel {
  int? spaceId;
  String? typeCode;
  String? typeName;
  String? statusCode;
  String? statusName;
  String? description;
  String? icon;
  String? color;
  SpaceModel({
    this.spaceId,
    this.typeCode,
    this.typeName,
    this.statusCode,
    this.statusName,
    this.description,
    this.icon,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'spaceId': spaceId,
      'typeCode': typeCode,
      'typeName': typeName,
      'statusCode': statusCode,
      'statusName': statusName,
      'description': description,
      // 'icon': icon,
      // 'color': color,
    };
  }

  factory SpaceModel.fromMap(Map<String, dynamic> map) {
    return SpaceModel(
      spaceId: map['spaceId'] != null ? map['spaceId'] as int : null,
      typeCode: map['typeCode'] != null ? map['typeCode'] as String : null,
      typeName: map['typeName'] != null ? map['typeName'] as String : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpaceModel.fromJson(Map<String, dynamic> source) =>
      SpaceModel.fromMap(source);

  // Clone method để copy object
  SpaceModel copyWith({
    int? spaceId,
    String? typeCode,
    String? typeName,
    String? statusCode,
    String? statusName,
    String? description,
    String? color,
    String? icon,
  }) {
    return SpaceModel(
      spaceId: spaceId ?? this.spaceId,
      typeCode: typeCode ?? this.typeCode,
      typeName: typeName ?? this.typeName,
      statusCode: statusCode ?? this.statusCode,
      statusName: statusName ?? this.statusName,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}
