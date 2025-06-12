class Profile {
  final String uid;
  final String? email;
  final String? name;
  final String? photoUrl;
  final String? curso;
  final String? carro;

  const Profile({
    required this.uid,
    this.email,
    this.name,
    this.photoUrl,
    this.curso,
    this.carro,
  });

  /// Creates a Profile from Firestore data
  factory Profile.fromFirebase(
    Map<String, dynamic> data, {
    required String uid,
    String? email,
  }) {
    return Profile(
      uid: uid,
      email: email,
      name: data['name'],
      photoUrl: data['photoUrl'],
      curso: data['curso'],
      carro: data['carro'],
    );
  }

  /// Converts to Firestore-compatible format
  Map<String, dynamic> toFirebase() {
    return {
      if (name != null) 'name': name,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (curso != null) 'curso': curso,
      if (carro != null) 'carro': carro,
    };
  }

  /// Creates a copy with updated fields
  Profile copyWith({
    String? name,
    String? photoUrl,
    String? curso,
    String? carro,
  }) {
    return Profile(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      curso: curso ?? this.curso,
      carro: carro ?? this.carro,
    );
  }
}
