class TransportModel {
  final String id;
  final String missionId;
  final String? userId;
  final String transportType; // 'train', 'bus', 'transfer'
  final String? company;
  final String? transportNumber;
  final String? departureLocation;
  final String? arrivalLocation;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String? bookingReference;
  final String? voucherCode;
  final String? ticketUrl;
  final String? status;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransportModel({
    required this.id,
    required this.missionId,
    this.userId,
    required this.transportType,
    this.company,
    this.transportNumber,
    this.departureLocation,
    this.arrivalLocation,
    required this.departureTime,
    required this.arrivalTime,
    this.bookingReference,
    this.voucherCode,
    this.ticketUrl,
    this.status,
    this.imageUrl,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    return TransportModel(
      id: json['id'],
      missionId: json['mission_id'],
      userId: json['user_id'],
      transportType: json['transport_type'],
      company: json['company'],
      transportNumber: json['transport_number'],
      departureLocation: json['departure_location'],
      arrivalLocation: json['arrival_location'],
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
      bookingReference: json['booking_reference'],
      voucherCode: json['voucher_code'],
      ticketUrl: json['ticket_url'],
      status: json['status'],
      imageUrl: json['image_url'],
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mission_id': missionId,
      'user_id': userId,
      'transport_type': transportType,
      'company': company,
      'transport_number': transportNumber,
      'departure_location': departureLocation,
      'arrival_location': arrivalLocation,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime.toIso8601String(),
      'booking_reference': bookingReference,
      'voucher_code': voucherCode,
      'ticket_url': ticketUrl,
      'status': status,
      'image_url': imageUrl,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
