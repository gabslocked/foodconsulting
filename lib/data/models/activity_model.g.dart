// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      id: json['id'] as String,
      missionId: json['mission_id'] as String,
      name: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      address: json['address'] as String?,
      priceRange: json['price_range'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      recommendedBy: json['recommended_by'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      website: json['website'] as String?,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mission_id': instance.missionId,
      'title': instance.name,
      'description': instance.description,
      'category': instance.category,
      'image_url': instance.imageUrl,
      'address': instance.address,
      'price_range': instance.priceRange,
      'rating': instance.rating,
      'recommended_by': instance.recommendedBy,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'website': instance.website,
      'phone': instance.phone,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
