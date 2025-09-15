import 'package:json_annotation/json_annotation.dart';

part 'technical_visit_model.g.dart';

@JsonSerializable()
class TechnicalVisitModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final String title;
  final String? description;
  final String? category; // 'wholesale', 'retail', 'logistics', 'manufacturing', etc.
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
  @JsonKey(name: 'visit_date')
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
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
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

  TechnicalVisitModel copyWith({
    String? id,
    String? missionId,
    String? title,
    String? description,
    String? category,
    String? companyName,
    String? location,
    String? address,
    Map<String, dynamic>? coordinates,
    String? contactPerson,
    String? contactEmail,
    String? contactPhone,
    DateTime? visitDate,
    String? visitTime,
    String? imageUrl,
    List<String>? images,
    int? displayOrder,
    bool? isActive,
    Map<String, dynamic>? metadata,
    String? recommendedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TechnicalVisitModel(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      companyName: companyName ?? this.companyName,
      location: location ?? this.location,
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
      contactPerson: contactPerson ?? this.contactPerson,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      visitDate: visitDate ?? this.visitDate,
      visitTime: visitTime ?? this.visitTime,
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
      case 'wholesale':
        return 'Atacado';
      case 'retail':
        return 'Varejo';
      case 'logistics':
        return 'Logística';
      case 'manufacturing':
        return 'Manufatura';
      case 'business':
        return 'Empresarial';
      default:
        return category ?? 'Visita Técnica';
    }
  }

  // Helper method to get visit date display
  String get visitDateDisplay {
    if (visitDate == null) return 'Data não informada';
    return '${visitDate!.day}/${visitDate!.month}/${visitDate!.year}';
  }

  // Helper method to get visit time display
  String get visitTimeDisplay {
    return visitTime ?? 'Horário não informado';
  }
}
