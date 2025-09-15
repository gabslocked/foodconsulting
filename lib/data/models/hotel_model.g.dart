// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotelModel _$HotelModelFromJson(Map<String, dynamic> json) => HotelModel(
      id: json['id'] as String,
      missionId: json['mission_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      category: json['category'] as String?,
      priority: json['priority'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      websiteUrl: json['website_url'] as String?,
      starRating: (json['star_rating'] as num?)?.toInt(),
      imageUrl: json['image_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$HotelModelToJson(HotelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mission_id': instance.missionId,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'priority': instance.priority,
      'address': instance.address,
      'phone': instance.phone,
      'website_url': instance.websiteUrl,
      'star_rating': instance.starRating,
      'image_url': instance.imageUrl,
      'metadata': instance.metadata,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
