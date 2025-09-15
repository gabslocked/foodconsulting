import 'package:json_annotation/json_annotation.dart';

part 'mission_model.g.dart';

@JsonSerializable()
class MissionModel {
  final String id;
  final String name;
  final String? description;
  final String country;
  final String city;
  @JsonKey(name: 'cover_image_url')
  final String? coverImageUrl;
  @JsonKey(name: 'start_date', fromJson: _dateFromJson)
  final DateTime startDate;
  @JsonKey(name: 'end_date', fromJson: _dateFromJson)
  final DateTime endDate;
  final String? currency;
  final double? exchangeRate;
  final String? timezone;
  final String? language;
  final double? averageTemperature;
  final String? emergencyContact;
  final String? emergencyPhone;
  final String status;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJsonNullable)
  final DateTime? updatedAt;

  const MissionModel({
    required this.id,
    required this.name,
    this.description,
    required this.country,
    required this.city,
    this.coverImageUrl,
    required this.startDate,
    required this.endDate,
    this.currency,
    this.exchangeRate,
    this.timezone,
    this.language,
    this.averageTemperature,
    this.emergencyContact,
    this.emergencyPhone,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) => _$MissionModelFromJson(json);
  Map<String, dynamic> toJson() => _$MissionModelToJson(this);

  MissionModel copyWith({
    String? id,
    String? name,
    String? description,
    String? country,
    String? city,
    String? coverImageUrl,
    DateTime? startDate,
    DateTime? endDate,
    String? currency,
    double? exchangeRate,
    String? timezone,
    String? language,
    double? averageTemperature,
    String? emergencyContact,
    String? emergencyPhone,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MissionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      country: country ?? this.country,
      city: city ?? this.city,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      averageTemperature: averageTemperature ?? this.averageTemperature,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Custom DateTime parsers for date fields
  static DateTime _dateFromJson(String dateString) {
    return DateTime.parse(dateString);
  }

  static DateTime _dateTimeFromJson(String dateTimeString) {
    final isoString = dateTimeString.replaceAll(' ', 'T') + 'Z';
    return DateTime.parse(isoString);
  }

  static DateTime? _dateTimeFromJsonNullable(String? dateTimeString) {
    if (dateTimeString == null) return null;
    return _dateTimeFromJson(dateTimeString);
  }
}

@JsonSerializable()
class MissionSummary {
  final String id;
  final String name;
  final String country;
  final String city;
  @JsonKey(name: 'cover_image_url')
  final String? coverImageUrl;
  @JsonKey(name: 'start_date', fromJson: MissionSummary._dateFromJson)
  final DateTime startDate;
  @JsonKey(name: 'end_date', fromJson: MissionSummary._dateFromJson)
  final DateTime endDate;
  final String status;

  const MissionSummary({
    required this.id,
    required this.name,
    required this.country,
    required this.city,
    this.coverImageUrl,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory MissionSummary.fromJson(Map<String, dynamic> json) => _$MissionSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$MissionSummaryToJson(this);

  // Custom DateTime parser for date fields
  static DateTime _dateFromJson(String dateString) {
    return DateTime.parse(dateString);
  }
}
