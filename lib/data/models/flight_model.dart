import 'package:json_annotation/json_annotation.dart';

part 'flight_model.g.dart';

@JsonSerializable()
class FlightModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'mission_id')
  final String missionId;
  final String? airline;
  @JsonKey(name: 'flight_number')
  final String? flightNumber;
  @JsonKey(name: 'departure_airport')
  final String? departureAirport;
  @JsonKey(name: 'arrival_airport')
  final String? arrivalAirport;
  @JsonKey(name: 'departure_time', fromJson: _dateTimeFromJson)
  final DateTime departureTime;
  @JsonKey(name: 'arrival_time', fromJson: _dateTimeFromJson)
  final DateTime arrivalTime;
  @JsonKey(name: 'seat_number')
  final String? seatNumber;
  @JsonKey(name: 'booking_reference')
  final String? bookingReference;
  final String? status;
  @JsonKey(name: 'ticket_url')
  final String? ticketUrl;
  final String? gate;
  final String? terminal;
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJsonNullable)
  final DateTime? updatedAt;

  const FlightModel({
    required this.id,
    required this.userId,
    required this.missionId,
    this.airline,
    this.flightNumber,
    this.departureAirport,
    this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    this.seatNumber,
    this.bookingReference,
    this.status,
    this.ticketUrl,
    this.gate,
    this.terminal,
    required this.createdAt,
    this.updatedAt,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) => _$FlightModelFromJson(json);
  Map<String, dynamic> toJson() => _$FlightModelToJson(this);

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      // Handle PostgreSQL timestamp format
      return DateTime.parse(value.replaceAll(' ', 'T'));
    }
    return DateTime.parse(value.toString());
  }

  static DateTime? _dateTimeFromJsonNullable(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      // Handle PostgreSQL timestamp format
      return DateTime.parse(value.replaceAll(' ', 'T'));
    }
    return DateTime.parse(value.toString());
  }

  FlightModel copyWith({
    String? id,
    String? userId,
    String? missionId,
    String? airline,
    String? flightNumber,
    String? departureAirport,
    String? arrivalAirport,
    DateTime? departureTime,
    DateTime? arrivalTime,
    String? seatNumber,
    String? bookingReference,
    String? status,
    String? ticketUrl,
    String? gate,
    String? terminal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FlightModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      missionId: missionId ?? this.missionId,
      airline: airline ?? this.airline,
      flightNumber: flightNumber ?? this.flightNumber,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      seatNumber: seatNumber ?? this.seatNumber,
      bookingReference: bookingReference ?? this.bookingReference,
      status: status ?? this.status,
      ticketUrl: ticketUrl ?? this.ticketUrl,
      gate: gate ?? this.gate,
      terminal: terminal ?? this.terminal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
