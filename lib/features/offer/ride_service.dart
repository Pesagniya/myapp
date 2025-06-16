import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/shared/ride_model.dart';

class RideService {
  final CollectionReference _ridesCollection = FirebaseFirestore.instance
      .collection('rides');

  Future<void> addRide(RideData ride) async {
    await _ridesCollection.add(ride.toMap());
  }
}
