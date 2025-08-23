class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? address;
  final String? photoUrl;
  final bool profileCompleted;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.address,
    this.photoUrl,
    this.profileCompleted = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? address,
    String? photoUrl,
    bool? profileCompleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      profileCompleted: profileCompleted ?? this.profileCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'address': address,
      'photoUrl': photoUrl,
      'profileCompleted': profileCompleted,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      gender: map['gender'],
      address: map['address'],
      photoUrl: map['photoUrl'],
      profileCompleted: map['profileCompleted'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, gender: $gender, address: $address, photoUrl: $photoUrl, profileCompleted: $profileCompleted)';
  }
}
