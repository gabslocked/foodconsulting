class DestinationModel {
  final String id;
  final String missionId;
  final String name;
  final String? description;
  final String city;
  final String country;
  final String? imageUrl;
  final String? linkUrl;
  final Map<String, dynamic>? coordinates;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  DestinationModel({
    required this.id,
    required this.missionId,
    required this.name,
    this.description,
    required this.city,
    required this.country,
    this.imageUrl,
    this.linkUrl,
    this.coordinates,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'],
      missionId: json['mission_id'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      country: json['country'],
      imageUrl: json['image_url'],
      linkUrl: json['link_url'],
      coordinates: json['coordinates'],
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
      'city': city,
      'country': country,
      'image_url': imageUrl,
      'link_url': linkUrl,
      'coordinates': coordinates,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
