import 'package:cloud_firestore/cloud_firestore.dart';

class RideData {
  final String? driverId;
  final String start;
  final String finish;
  final int? passengers;
  final DateTime? departure;

  RideData({
    this.driverId,
    required this.start,
    required this.finish,
    this.passengers,
    this.departure,
  });

  /// Create a new RideData with updated fields
  RideData copyWith({
    String? driverId,
    String? start,
    String? finish,
    int? passengers,
    DateTime? departure,
  }) {
    return RideData(
      driverId: driverId ?? this.driverId,
      start: start ?? this.start,
      finish: finish ?? this.finish,
      passengers: passengers ?? this.passengers,
      departure: departure ?? this.departure,
    );
  }

  /// Convert to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'start': start,
      'finish': finish,
      'passengers': passengers,
      'departureDateTime':
          departure != null ? Timestamp.fromDate(departure!) : null,
    };
  }

  /// Create RideData from Firestore map
  factory RideData.fromMap(Map<String, dynamic> map) {
    return RideData(
      driverId: map['driverId'],
      start: map['start'] ?? '',
      finish: map['finish'] ?? '',
      passengers: map['passengers'],
      departure: (map['departureDateTime'] as Timestamp?)?.toDate(),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RideData &&
        other.driverId == driverId &&
        other.start == start &&
        other.finish == finish &&
        other.passengers == passengers &&
        other.departure == departure;
  }

  @override
  int get hashCode =>
      Object.hash(driverId, start, finish, passengers, departure);
}
