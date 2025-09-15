import 'package:json_annotation/json_annotation.dart';

part 'accommodation_model.g.dart';

@JsonSerializable()
class AccommodationModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'mission_id')
  final String missionId;
  @JsonKey(name: 'hotel_name')
  final String? hotelName;
  final String? address;
  @JsonKey(name: 'room_number')
  final String? roomNumber;
  @JsonKey(name: 'check_in_date', fromJson: _dateFromJson)
  final DateTime checkInDate;
  @JsonKey(name: 'check_out_date', fromJson: _dateFromJson)
  final DateTime checkOutDate;
  @JsonKey(name: 'breakfast_time')
  final String? breakfastTime;
  @JsonKey(name: 'booking_reference')
  final String? bookingReference;
  @JsonKey(name: 'hotel_phone')
  final String? hotelPhone;
  @JsonKey(name: 'emergency_contact')
  final String? emergencyContact;
  @JsonKey(fromJson: _amenitiesFromJson)
  final List<String>? amenities;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'website_url')
  final String? websiteUrl;
  final double? latitude;
  final double? longitude;
  final String? status;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJsonNullable)
  final DateTime? updatedAt;

  const AccommodationModel({
    required this.id,
    required this.userId,
    required this.missionId,
    this.hotelName,
    this.address,
    this.roomNumber,
    required this.checkInDate,
    required this.checkOutDate,
    this.breakfastTime,
    this.bookingReference,
    this.hotelPhone,
    this.emergencyContact,
    this.amenities,
    this.imageUrl,
    this.websiteUrl,
    this.latitude,
    this.longitude,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory AccommodationModel.fromJson(Map<String, dynamic> json) => _$AccommodationModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccommodationModelToJson(this);

  static DateTime _dateFromJson(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      // Handle date-only format from PostgreSQL
      return DateTime.parse(value);
    }
    return DateTime.parse(value.toString());
  }

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      // Handle PostgreSQL timestamp format
      return DateTime.parse(value.replaceAll(' ', 'T'));
    }
    return DateTime.parse(value.toString());
  }

  static DateTime? _dateTimeFromJsonNullable(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      // Handle PostgreSQL timestamp format
      return DateTime.parse(value.replaceAll(' ', 'T'));
    }
    return DateTime.parse(value.toString());
  }

  static List<String>? _amenitiesFromJson(dynamic value) {
    if (value == null) return null;
    
    if (value is List) {
      // Handle array format: ["Wi-Fi", "Spa", "Restaurant"]
      return value.map((e) => e.toString()).toList();
    } else if (value is Map) {
      // Handle object format: {"wifi": "Wi-Fi gratuito", "services": [...]}
      List<String> amenitiesList = [];
      
      value.forEach((key, val) {
        if (val is String) {
          amenitiesList.add(val);
        } else if (val is List) {
          amenitiesList.addAll(val.map((e) => e.toString()));
        }
      });
      
      return amenitiesList;
    }
    
    return null;
  }

  AccommodationModel copyWith({
    String? id,
    String? userId,
    String? missionId,
    String? hotelName,
    String? address,
    String? roomNumber,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    String? breakfastTime,
    String? bookingReference,
    String? hotelPhone,
    String? emergencyContact,
    List<String>? amenities,
    String? imageUrl,
    String? websiteUrl,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccommodationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      missionId: missionId ?? this.missionId,
      hotelName: hotelName ?? this.hotelName,
      address: address ?? this.address,
      roomNumber: roomNumber ?? this.roomNumber,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      breakfastTime: breakfastTime ?? this.breakfastTime,
      bookingReference: bookingReference ?? this.bookingReference,
      hotelPhone: hotelPhone ?? this.hotelPhone,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      amenities: amenities ?? this.amenities,
      imageUrl: imageUrl ?? this.imageUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
