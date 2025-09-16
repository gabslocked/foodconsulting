// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TourModel _$TourModelFromJson(Map<String, dynamic> json) => TourModel(
      id: json['id'] as String,
      missionId: json['mission_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      location: json['location'] as String?,
      address: json['address'] as String?,
      coordinates: json['coordinates'] as Map<String, dynamic>?,
      duration: json['duration'] as String?,
      imageUrl: json['image_url'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      displayOrder: (json['display_order'] as num).toInt(),
      isActive: json['is_active'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
      recommendedBy: json['recommended_by'] as String?,
      createdAt: TourModel._dateTimeFromJson(json['created_at']),
      updatedAt: TourModel._dateTimeFromJsonNullable(json['updated_at']),
    );

Map<String, dynamic> _$TourModelToJson(TourModel instance) => <String, dynamic>{
      'id': instance.id,
      'mission_id': instance.missionId,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'location': instance.location,
      'address': instance.address,
      'coordinates': instance.coordinates,
      'duration': instance.duration,
      'image_url': instance.imageUrl,
      'images': instance.images,
      'display_order': instance.displayOrder,
      'is_active': instance.isActive,
      'metadata': instance.metadata,
      'recommended_by': instance.recommendedBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
