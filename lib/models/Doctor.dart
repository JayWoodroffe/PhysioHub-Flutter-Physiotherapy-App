class Doctor{ final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String profilePicture;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
  });

  //converting the firebase data to model
  factory Doctor.fromMap(Map<String, dynamic> data,  String documentId) {
    return Doctor(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'],
      profilePicture: data['profilePicture'] ?? '',
    );
  }

  //converting model to firebase format
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }
}