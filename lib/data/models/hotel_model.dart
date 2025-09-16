import 'package:json_annotation/json_annotation.dart';

part 'hotel_model.g.dart';

@JsonSerializable()
class HotelModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final String category;
  final String title;
  final String content;
  final String priority;
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
  final String createdBy;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'display_order')
  final int displayOrder;

  const HotelModel({
    required this.id,
    required this.missionId,
    required this.category,
    required this.title,
    required this.content,
    required this.priority,
    this.address,
    this.phone,
    this.websiteUrl,
    this.starRating,
    this.imageUrl,
    this.metadata,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.displayOrder,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) => _$HotelModelFromJson(json);
  Map<String, dynamic> toJson() => _$HotelModelToJson(this);

  // Helper getters for metadata fields
  String? get wifi => metadata?['wifi'];
  String? get rooms => metadata?['rooms'];
  List<String>? get services => metadata?['services']?.cast<String>();
  List<String>? get wellness => metadata?['wellness']?.cast<String>();
  String? get transport => metadata?['transport'];
  List<String>? get facilities => metadata?['facilities']?.cast<String>();
  List<String>? get restaurants => metadata?['restaurants']?.cast<String>();
  List<String>? get nearbyAttractions => metadata?['nearby_attractions']?.cast<String>();
  int? get metadataStarRating => metadata?['star_rating'];

}
