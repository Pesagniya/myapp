import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String? senderPhotoUrl;
  final String receiverId;
  final String content;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    this.senderPhotoUrl,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'senderPhotoUrl': senderPhotoUrl,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
