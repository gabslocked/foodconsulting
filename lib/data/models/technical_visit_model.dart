import 'package:json_annotation/json_annotation.dart';

part 'technical_visit_model.g.dart';

@JsonSerializable()
class TechnicalVisitModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final String title;
  final String? description;
  final String? category;
  @JsonKey(name: 'company_name')
  final String? companyName;
  final String? location;
  final String? address;
  final Map<String, dynamic>? coordinates;
  @JsonKey(name: 'contact_person')
  final String? contactPerson;
  @JsonKey(name: 'contact_email')
  final String? contactEmail;
  @JsonKey(name: 'contact_phone')
  final String? contactPhone;
  @JsonKey(name: 'visit_date', fromJson: _dateFromJsonNullable)
  final DateTime? visitDate;
  @JsonKey(name: 'visit_time')
  final String? visitTime;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final List<String>? images;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'recommended_by')
  final String? recommendedBy;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJsonNullable)
  final DateTime? updatedAt;

  const TechnicalVisitModel({
    required this.id,
    required this.missionId,
    required this.title,
    this.description,
    this.category,
    this.companyName,
    this.location,
    this.address,
    this.coordinates,
    this.contactPerson,
    this.contactEmail,
    this.contactPhone,
    this.visitDate,
    this.visitTime,
    this.imageUrl,
    this.images,
    required this.displayOrder,
    required this.isActive,
    this.metadata,
    this.recommendedBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory TechnicalVisitModel.fromJson(Map<String, dynamic> json) => _$TechnicalVisitModelFromJson(json);
  Map<String, dynamic> toJson() => _$TechnicalVisitModelToJson(this);


  static DateTime? _dateFromJsonNullable(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.parse(value.toString());
  }

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      return DateTime.parse(value.replaceAll(' ', 'T'));
    }
    return DateTime.parse(value.toString());
  }

  static DateTime? _dateTimeFromJsonNullable(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return DateTime.parse(value.replaceAll(' ', 'T'));
    }
    return DateTime.parse(value.toString());
  }
}
