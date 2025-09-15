class SponsorModel {
  final String id;
  final String missionId;
  final String name;
  final String? description;
  final String logoUrl;
  final String? websiteUrl;
  final String sponsorType; // 'main', 'supporter', 'partner'
  final int displayOrder;
  final bool isActive;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  SponsorModel({
    required this.id,
    required this.missionId,
    required this.name,
    this.description,
    required this.logoUrl,
    this.websiteUrl,
    required this.sponsorType,
    required this.displayOrder,
    required this.isActive,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SponsorModel.fromJson(Map<String, dynamic> json) {
    return SponsorModel(
      id: json['id'],
      missionId: json['mission_id'],
      name: json['name'],
      description: json['description'],
      logoUrl: json['logo_url'],
      websiteUrl: json['website_url'],
      sponsorType: json['sponsor_type'],
      displayOrder: json['display_order'] ?? 0,
      isActive: json['is_active'] ?? true,
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mission_id': missionId,
      'name': name,
      'description': description,
      'logo_url': logoUrl,
      'website_url': websiteUrl,
      'sponsor_type': sponsorType,
      'display_order': displayOrder,
      'is_active': isActive,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
