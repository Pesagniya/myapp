import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/shared/ride_model.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getRides() {
    return _firestore.collection('rides').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final ride = doc.data();
        return ride;
      }).toList();
    });
  }

  Future<bool> applyToRide({
    required String rideId,
    required String userId,
  }) async {
    final rideRef = _firestore.collection('rides').doc(rideId);
    final userRef = _firestore.collection('users').doc(userId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final rideSnapshot = await transaction.get(rideRef);
        if (!rideSnapshot.exists) throw Exception();

        final data = rideSnapshot.data()!;
        final ride = RideData.fromMap(data);

        final currentPassengerIds = List<String>.from(ride.passengerIds ?? []);

        // Prevent driver or duplicate entry
        if (currentPassengerIds.contains(userId) || ride.driverId == userId) {
          throw Exception();
        }

        // Prevents joining full rides
        if (ride.seats! == 0) {
          throw Exception();
        }

        final updatedPassengerIds = [...currentPassengerIds, userId];
        final updatedRide = ride.copyWith(
          passengerIds: updatedPassengerIds,
          seats: ride.seats! - 1,
        );

        transaction.set(rideRef, updatedRide.toMap());

        // Also update user
        transaction.set(userRef, {
          'joinedRides': FieldValue.arrayUnion([rideId]),
        }, SetOptions(merge: true));
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
