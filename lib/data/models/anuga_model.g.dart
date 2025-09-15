// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anuga_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnugaModel _$AnugaModelFromJson(Map<String, dynamic> json) => AnugaModel(
      id: json['id'] as String,
      missionId: json['mission_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      linkUrl: json['link_url'] as String?,
      eventDate: json['event_date'] == null
          ? null
          : DateTime.parse(json['event_date'] as String),
      location: json['location'] as String?,
      boothNumber: json['booth_number'] as String?,
      contactInfo: json['contact_info'] as String?,
      isActive: json['is_active'] as bool,
      displayOrder: (json['display_order'] as num).toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: AnugaModel._parseDateTime(json['created_at']),
      updatedAt: AnugaModel._parseOptionalDateTime(json['updated_at']),
    );

Map<String, dynamic> _$AnugaModelToJson(AnugaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mission_id': instance.missionId,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'link_url': instance.linkUrl,
      'event_date': instance.eventDate?.toIso8601String(),
      'location': instance.location,
      'booth_number': instance.boothNumber,
      'contact_info': instance.contactInfo,
      'is_active': instance.isActive,
      'display_order': instance.displayOrder,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
