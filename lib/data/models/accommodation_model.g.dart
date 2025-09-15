// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accommodation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccommodationModel _$AccommodationModelFromJson(Map<String, dynamic> json) =>
    AccommodationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      missionId: json['mission_id'] as String,
      hotelName: json['hotel_name'] as String?,
      address: json['address'] as String?,
      roomNumber: json['room_number'] as String?,
      checkInDate: AccommodationModel._dateFromJson(json['check_in_date']),
      checkOutDate: AccommodationModel._dateFromJson(json['check_out_date']),
      breakfastTime: json['breakfast_time'] as String?,
      bookingReference: json['booking_reference'] as String?,
      hotelPhone: json['hotel_phone'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
      amenities: AccommodationModel._amenitiesFromJson(json['amenities']),
      imageUrl: json['image_url'] as String?,
      websiteUrl: json['website_url'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String?,
      createdAt: AccommodationModel._dateTimeFromJson(json['created_at']),
      updatedAt:
          AccommodationModel._dateTimeFromJsonNullable(json['updated_at']),
    );

Map<String, dynamic> _$AccommodationModelToJson(AccommodationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'mission_id': instance.missionId,
      'hotel_name': instance.hotelName,
      'address': instance.address,
      'room_number': instance.roomNumber,
      'check_in_date': instance.checkInDate.toIso8601String(),
      'check_out_date': instance.checkOutDate.toIso8601String(),
      'breakfast_time': instance.breakfastTime,
      'booking_reference': instance.bookingReference,
      'hotel_phone': instance.hotelPhone,
      'emergency_contact': instance.emergencyContact,
      'amenities': instance.amenities,
      'image_url': instance.imageUrl,
      'website_url': instance.websiteUrl,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
