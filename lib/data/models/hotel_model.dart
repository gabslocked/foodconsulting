import 'package:json_annotation/json_annotation.dart';

part 'hotel_model.g.dart';

@JsonSerializable()
class HotelModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final String title;
  final String? content;
  final String? category; // 'düsseldorf', 'berlin', 'cologne', etc.
  final String? priority; // 'alta', 'normal', 'baixa'
  final String? address;
  final String? phone;
  @JsonKey(name: 'website_url')
  final String? websiteUrl;
  @JsonKey(name: 'star_rating')
  final int? starRating;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const HotelModel({
    required this.id,
    required this.missionId,
    required this.title,
    this.content,
    this.category,
    this.priority,
    this.address,
    this.phone,
    this.websiteUrl,
    this.starRating,
    this.imageUrl,
    this.metadata,
    this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) => _$HotelModelFromJson(json);
  Map<String, dynamic> toJson() => _$HotelModelToJson(this);

  HotelModel copyWith({
    String? id,
    String? missionId,
    String? title,
    String? content,
    String? category,
    String? priority,
    String? address,
    String? phone,
    String? websiteUrl,
    int? starRating,
    String? imageUrl,
    Map<String, dynamic>? metadata,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HotelModel(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      starRating: starRating ?? this.starRating,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to get amenities from metadata
  List<String> get amenities {
    if (metadata == null) return [];
    final amenitiesList = metadata!['amenities'] as List?;
    return amenitiesList?.map((e) => e.toString()).toList() ?? [];
  }

  // Helper method to get star rating display
  String get starRatingDisplay {
    if (starRating == null) return '';
    return '★' * starRating!;
  }

  // Helper method to get nearby attractions
  List<String> get nearbyAttractions {
    if (metadata == null) return [];
    final attractions = metadata!['nearby_attractions'] as List?;
    return attractions?.map((e) => e.toString()).toList() ?? [];
  }
}
