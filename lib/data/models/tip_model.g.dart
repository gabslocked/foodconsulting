// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipModel _$TipModelFromJson(Map<String, dynamic> json) => TipModel(
      id: json['id'] as String,
      missionId: json['mission_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      category: json['category'] as String?,
      priority: json['priority'] as String?,
      authorName: json['author_name'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TipModelToJson(TipModel instance) => <String, dynamic>{
      'id': instance.id,
      'mission_id': instance.missionId,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'priority': instance.priority,
      'author_name': instance.authorName,
      'image_url': instance.imageUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
