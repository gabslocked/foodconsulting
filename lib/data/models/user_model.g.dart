// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      company: json['company'] as String?,
      role: json['role'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      documentNumber: json['document_number'] as String?,
      passportNumber: json['passport_number'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>?,
      createdAt: UserModel._dateTimeFromJson(json['created_at'] as String),
      updatedAt:
          UserModel._dateTimeFromJsonNullable(json['updated_at'] as String?),
      isFirstLogin: json['is_first_login'] as bool?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'company': instance.company,
      'role': instance.role,
      'avatar_url': instance.avatarUrl,
      'document_number': instance.documentNumber,
      'passport_number': instance.passportNumber,
      'preferences': instance.preferences,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_first_login': instance.isFirstLogin,
    };
