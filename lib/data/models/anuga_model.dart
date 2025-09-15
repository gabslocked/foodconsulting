import 'package:json_annotation/json_annotation.dart';

part 'anuga_model.g.dart';

@JsonSerializable()
class AnugaModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final String title;
  final String? description;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'link_url')
  final String? linkUrl;
  @JsonKey(name: 'event_date')
  final DateTime? eventDate;
  final String? location;
  @JsonKey(name: 'booth_number')
  final String? boothNumber;
  @JsonKey(name: 'contact_info')
  final String? contactInfo;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  final Map<String, dynamic>? metadata;
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

  const AnugaModel({
    required this.id,
    required this.missionId,
    required this.title,
    this.description,
    this.imageUrl,
    this.linkUrl,
    this.eventDate,
    this.location,
    this.boothNumber,
    this.contactInfo,
    required this.isActive,
    required this.displayOrder,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  factory AnugaModel.fromJson(Map<String, dynamic> json) => _$AnugaModelFromJson(json);
  Map<String, dynamic> toJson() => _$AnugaModelToJson(this);

  AnugaModel copyWith({
    String? id,
    String? missionId,
    String? title,
    String? description,
    String? imageUrl,
    String? linkUrl,
    DateTime? eventDate,
    String? location,
    String? boothNumber,
    String? contactInfo,
    bool? isActive,
    int? displayOrder,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AnugaModel(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      linkUrl: linkUrl ?? this.linkUrl,
      eventDate: eventDate ?? this.eventDate,
      location: location ?? this.location,
      boothNumber: boothNumber ?? this.boothNumber,
      contactInfo: contactInfo ?? this.contactInfo,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
