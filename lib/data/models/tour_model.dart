import 'package:json_annotation/json_annotation.dart';

part 'tour_model.g.dart';

@JsonSerializable()
class TourModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final String title;
  final String? description;
  final String? category; // 'cultural', 'experiential', 'walking', 'food', etc.
  final String? location;
  final String? address;
  final Map<String, dynamic>? coordinates;
  final String? duration; // tour duration like '2 hours', 'half day'
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
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
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

  TourModel copyWith({
    String? id,
    String? missionId,
    String? title,
    String? description,
    String? category,
    String? location,
    String? address,
    Map<String, dynamic>? coordinates,
    String? duration,
    String? imageUrl,
    List<String>? images,
    int? displayOrder,
    bool? isActive,
    Map<String, dynamic>? metadata,
    String? recommendedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TourModel(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
      recommendedBy: recommendedBy ?? this.recommendedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to get category display name
  String get categoryDisplayName {
    switch (category?.toLowerCase()) {
      case 'cultural':
        return 'Cultural';
      case 'experiential':
        return 'Experiencial';
      case 'walking':
        return 'Caminhada';
      case 'food':
        return 'Gastronômico';
      default:
        return category ?? 'Tour';
    }
  }

  // Helper method to get duration display
  String get durationDisplay {
    return duration ?? 'Duração não informada';
  }
}
