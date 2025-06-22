import 'package:cloud_firestore/cloud_firestore.dart';

class RideData {
  final String? rideId;
  final String? driverId;
  final String? email;
  final String? photoURL;
  final String start;
  final String finish;
  final int? seats;
  final List<String>? passengerIds;
  final DateTime? departure;
  final double? price;

  RideData({
    this.rideId,
    this.driverId,
    this.email,
    this.photoURL,
    required this.start,
    required this.finish,
    this.seats,
    this.departure,
    this.passengerIds,
    this.price,
  });

  /// Create a new RideData with updated fields
  RideData copyWith({
    String? rideId,
    String? driverId,
    String? email,
    String? photoURL,
    String? start,
    String? finish,
    int? seats,
    List<String>? passengerIds,
    DateTime? departure,
    double? price,
  }) {
    return RideData(
      rideId: rideId ?? this.rideId,
      driverId: driverId ?? this.driverId,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      start: start ?? this.start,
      finish: finish ?? this.finish,
      seats: seats ?? this.seats,
      passengerIds: passengerIds ?? this.passengerIds,
      departure: departure ?? this.departure,
      price: price ?? this.price,
    );
  }

  /// Convert to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
      'driverId': driverId,
      'email': email,
      'photoURL': photoURL,
      'start': start,
      'finish': finish,
      'seats': seats,
      'passengerIds': passengerIds,
      'departureDateTime': Timestamp.fromDate(departure!),
      'price': price,
    };
  }

  /// Create RideData from Firestore map
  factory RideData.fromMap(Map<String, dynamic> map) {
    return RideData(
      rideId: map['rideId'],
      driverId: map['driverId'],
      email: map['email'],
      photoURL: map['photoURL'],
      start: map['start'] ?? '',
      finish: map['finish'] ?? '',
      seats: map['seats'],
      passengerIds: List<String>.from(map['passengerIds'] ?? []),
      departure: (map['departureDateTime'] as Timestamp?)?.toDate(),
      price: (map['price'] as num?)?.toDouble(),
    );
  }
}
