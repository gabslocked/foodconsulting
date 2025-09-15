import 'package:json_annotation/json_annotation.dart';

part 'tip_model.g.dart';

@JsonSerializable()
class TipModel {
  final String id;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final String title;
  final String? content;
  final String? category; // 'transporte', 'alimentacao', 'seguranca', 'cultura', 'outros'
  final String? priority; // 'alta', 'normal', 'baixa'
  @JsonKey(name: 'author_name')
  final String? authorName;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const TipModel({
    required this.id,
    required this.missionId,
    required this.title,
    this.content,
    this.category,
    this.priority,
    this.authorName,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory TipModel.fromJson(Map<String, dynamic> json) => _$TipModelFromJson(json);
  Map<String, dynamic> toJson() => _$TipModelToJson(this);

  TipModel copyWith({
    String? id,
    String? missionId,
    String? title,
    String? content,
    String? category,
    String? priority,
    String? authorName,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TipModel(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      authorName: authorName ?? this.authorName,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
