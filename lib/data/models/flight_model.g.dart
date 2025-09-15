// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlightModel _$FlightModelFromJson(Map<String, dynamic> json) => FlightModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      missionId: json['mission_id'] as String,
      airline: json['airline'] as String?,
      flightNumber: json['flight_number'] as String?,
      departureAirport: json['departure_airport'] as String?,
      arrivalAirport: json['arrival_airport'] as String?,
      departureTime: FlightModel._dateTimeFromJson(json['departure_time']),
      arrivalTime: FlightModel._dateTimeFromJson(json['arrival_time']),
      seatNumber: json['seat_number'] as String?,
      bookingReference: json['booking_reference'] as String?,
      status: json['status'] as String?,
      ticketUrl: json['ticket_url'] as String?,
      gate: json['gate'] as String?,
      terminal: json['terminal'] as String?,
      createdAt: FlightModel._dateTimeFromJson(json['created_at']),
      updatedAt: FlightModel._dateTimeFromJsonNullable(json['updated_at']),
    );

Map<String, dynamic> _$FlightModelToJson(FlightModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'mission_id': instance.missionId,
      'airline': instance.airline,
      'flight_number': instance.flightNumber,
      'departure_airport': instance.departureAirport,
      'arrival_airport': instance.arrivalAirport,
      'departure_time': instance.departureTime.toIso8601String(),
      'arrival_time': instance.arrivalTime.toIso8601String(),
      'seat_number': instance.seatNumber,
      'booking_reference': instance.bookingReference,
      'status': instance.status,
      'ticket_url': instance.ticketUrl,
      'gate': instance.gate,
      'terminal': instance.terminal,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
