import 'package:cloud_firestore/cloud_firestore.dart';

class RideData {
  final String start;
  final String finish;
  final int? passengers;
  final DateTime? departure;
  final String? driverId; // new field for auth user ID

  RideData({
    required this.start,
    required this.finish,
    this.passengers,
    this.departure,
    this.driverId,
  });

  /// Create a new RideData with updated fields
  RideData copyWith({
    String? start,
    String? finish,
    int? passengers,
    DateTime? departure,
    String? driverId,
  }) {
    return RideData(
      start: start ?? this.start,
      finish: finish ?? this.finish,
      passengers: passengers ?? this.passengers,
      departure: departure ?? this.departure,
      driverId: driverId ?? this.driverId,
    );
  }

  /// Convert to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'finish': finish,
      'passengers': passengers,
      'departureDateTime':
          departure != null ? Timestamp.fromDate(departure!) : null,
      'driverId': driverId,
    };
  }

  /// Create RideData from Firestore map
  factory RideData.fromMap(Map<String, dynamic> map) {
    return RideData(
      start: map['start'] ?? '',
      finish: map['finish'] ?? '',
      passengers: map['passengers'],
      departure: (map['departureDateTime'] as Timestamp?)?.toDate(),
      driverId: map['driverId'],
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RideData &&
        other.start == start &&
        other.finish == finish &&
        other.passengers == passengers &&
        other.departure == departure &&
        other.driverId == driverId;
  }

  @override
  int get hashCode =>
      Object.hash(start, finish, passengers, departure, driverId);
}
