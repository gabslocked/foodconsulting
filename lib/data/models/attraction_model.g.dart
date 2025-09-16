// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attraction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttractionModel _$AttractionModelFromJson(Map<String, dynamic> json) =>
    AttractionModel(
      id: json['id'] as String,
      missionId: json['mission_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      location: json['location'] as String?,
      address: json['address'] as String?,
      coordinates: json['coordinates'] as Map<String, dynamic>?,
      imageUrl: json['image_url'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      displayOrder: (json['display_order'] as num).toInt(),
      cityOrder: (json['city_order'] as num?)?.toInt(),
      isActive: json['is_active'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
      recommendedBy: json['recommended_by'] as String?,
      createdAt: AttractionModel._dateTimeFromJson(json['created_at']),
      updatedAt: AttractionModel._dateTimeFromJsonNullable(json['updated_at']),
    );

Map<String, dynamic> _$AttractionModelToJson(AttractionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mission_id': instance.missionId,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'location': instance.location,
      'address': instance.address,
      'coordinates': instance.coordinates,
      'image_url': instance.imageUrl,
      'images': instance.images,
      'display_order': instance.displayOrder,
      'city_order': instance.cityOrder,
      'is_active': instance.isActive,
      'metadata': instance.metadata,
      'recommended_by': instance.recommendedBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
