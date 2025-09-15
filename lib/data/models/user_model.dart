import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? phone;
  final String? company;
  final String? role;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'document_number')
  final String? documentNumber;
  @JsonKey(name: 'passport_number')
  final String? passportNumber;
  final Map<String, dynamic>? preferences;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJsonNullable)
  final DateTime? updatedAt;
  @JsonKey(name: 'is_first_login')
  final bool? isFirstLogin;

  const UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.company,
    this.role,
    this.avatarUrl,
    this.documentNumber,
    this.passportNumber,
    this.preferences,
    required this.createdAt,
    this.updatedAt,
    this.isFirstLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? company,
    String? role,
    String? avatarUrl,
    String? documentNumber,
    String? passportNumber,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFirstLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      documentNumber: documentNumber ?? this.documentNumber,
      passportNumber: passportNumber ?? this.passportNumber,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
    );
  }

  // Custom DateTime parsers for PostgreSQL timestamp format
  static DateTime _dateTimeFromJson(String dateTimeString) {
    // Convert PostgreSQL timestamp to ISO8601 format
    final isoString = dateTimeString.replaceAll(' ', 'T') + 'Z';
    return DateTime.parse(isoString);
  }

  static DateTime? _dateTimeFromJsonNullable(String? dateTimeString) {
    if (dateTimeString == null) return null;
    return _dateTimeFromJson(dateTimeString);
  }
}
