import 'package:json_annotation/json_annotation.dart';

part 'tour_model.g.dart';

@JsonSerializable()
class TourModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final String title;
  final String? description;
  final String? category;
  final String? location;
  final String? address;
  final Map<String, dynamic>? coordinates;
  final String? duration;
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

  const TourModel({
    required this.id,
    required this.missionId,
    required this.title,
    this.description,
    this.category,
    this.location,
    this.address,
    this.coordinates,
    this.duration,
    this.imageUrl,
    this.images,
    required this.displayOrder,
    required this.isActive,
    this.metadata,
    this.recommendedBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) => _$TourModelFromJson(json);
  Map<String, dynamic> toJson() => _$TourModelToJson(this);


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
