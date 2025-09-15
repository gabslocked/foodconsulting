import 'package:json_annotation/json_annotation.dart';
import '../../core/enums/activity_category.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  @JsonKey(name: 'title')
  final String name;
  final String? description;
  final String? category; // 'restaurantes', 'turismo', 'compras', 'cultura'
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final String? address;
  @JsonKey(name: 'price_range')
  final String? priceRange; // '$', '$$', '$$$'
  final double? rating;
  @JsonKey(name: 'recommended_by')
  final String? recommendedBy;
  final double? latitude;
  final double? longitude;
  final String? website;
  final String? phone;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ActivityModel({
    required this.id,
    required this.missionId,
    required this.name,
    this.description,
    this.category,
    this.imageUrl,
    this.address,
    this.priceRange,
    this.rating,
    this.recommendedBy,
    this.latitude,
    this.longitude,
    this.website,
    this.phone,
    required this.createdAt,
    this.updatedAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  /// Retorna a categoria como enum
  ActivityCategory? get categoryEnum => ActivityCategory.fromValue(category ?? '');

  /// Verifica se é uma visita técnica
  bool get isVisit => categoryEnum?.isVisitCategory ?? false;

  /// Verifica se é um tour cultural
  bool get isTour => categoryEnum?.isTourCategory ?? false;

  /// Verifica se é uma atração turística
  bool get isAttraction => categoryEnum?.isAttractionCategory ?? false;

  ActivityModel copyWith({
    String? id,
    String? missionId,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    String? address,
    String? priceRange,
    double? rating,
    String? recommendedBy,
    double? latitude,
    double? longitude,
    String? website,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      recommendedBy: recommendedBy ?? this.recommendedBy,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      website: website ?? this.website,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
