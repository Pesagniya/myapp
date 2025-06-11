import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/chat/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getChats() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverId, message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final String currentUserPhotoURL = _auth.currentUser!.photoURL!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      senderPhotoUrl: currentUserPhotoURL,
      receiverId: receiverId,
      content: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection('Chat')
        .doc(chatRoomID)
        .collection('Messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, receiverId) {
    List<String> ids = [userId, receiverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('Chat')
        .doc(chatRoomID)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
