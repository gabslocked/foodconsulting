// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MissionModel _$MissionModelFromJson(Map<String, dynamic> json) => MissionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      country: json['country'] as String,
      city: json['city'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      startDate: MissionModel._dateFromJson(json['start_date'] as String),
      endDate: MissionModel._dateFromJson(json['end_date'] as String),
      currency: json['currency'] as String?,
      exchangeRate: (json['exchangeRate'] as num?)?.toDouble(),
      timezone: json['timezone'] as String?,
      language: json['language'] as String?,
      averageTemperature: (json['averageTemperature'] as num?)?.toDouble(),
      emergencyContact: json['emergencyContact'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
      status: json['status'] as String,
      createdAt: MissionModel._dateTimeFromJson(json['created_at'] as String),
      updatedAt:
          MissionModel._dateTimeFromJsonNullable(json['updated_at'] as String?),
    );

Map<String, dynamic> _$MissionModelToJson(MissionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'country': instance.country,
      'city': instance.city,
      'cover_image_url': instance.coverImageUrl,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'currency': instance.currency,
      'exchangeRate': instance.exchangeRate,
      'timezone': instance.timezone,
      'language': instance.language,
      'averageTemperature': instance.averageTemperature,
      'emergencyContact': instance.emergencyContact,
      'emergencyPhone': instance.emergencyPhone,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

MissionSummary _$MissionSummaryFromJson(Map<String, dynamic> json) =>
    MissionSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      startDate: MissionSummary._dateFromJson(json['start_date'] as String),
      endDate: MissionSummary._dateFromJson(json['end_date'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$MissionSummaryToJson(MissionSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
      'city': instance.city,
      'cover_image_url': instance.coverImageUrl,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'status': instance.status,
    };
