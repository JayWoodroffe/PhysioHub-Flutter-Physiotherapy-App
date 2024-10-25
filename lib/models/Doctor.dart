class Doctor{ final String id;
  final String name;
  final String email;
  final String profilePicture;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  //converting the firebase data to model
  factory Doctor.fromMap(Map<String, dynamic> data) {
    return Doctor(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
    );
  }

  //converting model to firebase format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}