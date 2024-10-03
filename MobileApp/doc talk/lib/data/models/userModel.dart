class UserData {
  final String name;
  final String email;
  final String userId;
  late String profileImageUrl;

  UserData({
    required this.name,
    required this.email,
    required this.userId,
    String profileImageUrl = '',
  })  : profileImageUrl = profileImageUrl;

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] as String,
      email: map['email'] as String,
      userId: map['userId'] as String,
      profileImageUrl: map['profileImageUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'userId': userId,
      'profileImageUrl': profileImageUrl,
    };
  }

}
