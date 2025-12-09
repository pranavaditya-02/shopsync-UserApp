class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final List<String> addresses;
  final int loyaltyPoints;
  final String loyaltyTier;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    required this.addresses,
    required this.loyaltyPoints,
    required this.loyaltyTier,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'addresses': addresses,
      'loyaltyPoints': loyaltyPoints,
      'loyaltyTier': loyaltyTier,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      addresses: List<String>.from(json['addresses']),
      loyaltyPoints: json['loyaltyPoints'],
      loyaltyTier: json['loyaltyTier'],
    );
  }
}
