// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_visit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechnicalVisitModel _$TechnicalVisitModelFromJson(Map<String, dynamic> json) =>
    TechnicalVisitModel(
      id: json['id'] as String,
      missionId: json['mission_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      companyName: json['company_name'] as String?,
      location: json['location'] as String?,
      address: json['address'] as String?,
      coordinates: json['coordinates'] as Map<String, dynamic>?,
      contactPerson: json['contact_person'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      visitDate: TechnicalVisitModel._dateFromJsonNullable(json['visit_date']),
      visitTime: json['visit_time'] as String?,
      imageUrl: json['image_url'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      displayOrder: (json['display_order'] as num).toInt(),
      isActive: json['is_active'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
      recommendedBy: json['recommended_by'] as String?,
      createdAt: TechnicalVisitModel._dateTimeFromJson(json['created_at']),
      updatedAt:
          TechnicalVisitModel._dateTimeFromJsonNullable(json['updated_at']),
    );

Map<String, dynamic> _$TechnicalVisitModelToJson(
        TechnicalVisitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mission_id': instance.missionId,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'company_name': instance.companyName,
      'location': instance.location,
      'address': instance.address,
      'coordinates': instance.coordinates,
      'contact_person': instance.contactPerson,
      'contact_email': instance.contactEmail,
      'contact_phone': instance.contactPhone,
      'visit_date': instance.visitDate?.toIso8601String(),
      'visit_time': instance.visitTime,
      'image_url': instance.imageUrl,
      'images': instance.images,
      'display_order': instance.displayOrder,
      'is_active': instance.isActive,
      'metadata': instance.metadata,
      'recommended_by': instance.recommendedBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
