import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/shared/ride_model.dart';

class RideService {
  final CollectionReference _ridesCollection = FirebaseFirestore.instance
      .collection('rides');

  Future<void> addRide(RideData ride) async {
    final docRef = _ridesCollection.doc(); // generates the ID
    final rideWithId = ride.copyWith(rideId: docRef.id);

    await docRef.set(rideWithId.toMap());
  }

  Future<String> getPhoto() async {
    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    return userDoc.data()?['photoURL'];
  }
}
