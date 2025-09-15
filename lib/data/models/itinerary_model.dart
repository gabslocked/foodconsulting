import 'package:json_annotation/json_annotation.dart';

part 'itinerary_model.g.dart';

@JsonSerializable()
class ItineraryModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final DateTime date;
  @JsonKey(name: 'start_time')
  final String? startTime;
  @JsonKey(name: 'end_time')
  final String? endTime;
  final String title;
  final String? description;
  final String? location;
  @JsonKey(name: 'location_address')
  final String? address;
  @JsonKey(name: 'is_mandatory')
  final bool isMandatory;
  final String type;
  final double? latitude;
  final double? longitude;
  @JsonKey(name: 'created_at', fromJson: _parseDateTime)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', fromJson: _parseOptionalDateTime)
  final DateTime? updatedAt;

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  static DateTime? _parseOptionalDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.parse(value);
    return null;
  }

  const ItineraryModel({
    required this.id,
    required this.missionId,
    required this.date,
    this.startTime,
    this.endTime,
    required this.title,
    this.description,
    this.location,
    this.address,
    required this.isMandatory,
    required this.type,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.updatedAt,
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) => _$ItineraryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryModelToJson(this);

  ItineraryModel copyWith({
    String? id,
    String? missionId,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? title,
    String? description,
    String? location,
    String? address,
    bool? isMandatory,
    String? type,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItineraryModel(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      address: address ?? this.address,
      isMandatory: isMandatory ?? this.isMandatory,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
