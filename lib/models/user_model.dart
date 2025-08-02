class User {
  int? id;
  final String username;
  final String email;
  final String fullName;
  final String lastName;
  final String password;
  final String licenseNumber;
  final String phoneNumber;
  final String token;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.lastName,
    required this.password,
    required this.licenseNumber,
    required this.phoneNumber,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'],
      lastName: json['last_name'],
      password: json['password'],
      licenseNumber: json['license_number'],
      phoneNumber: json['phone_number'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'last_name': lastName,
      'password': password,
      'license_number': licenseNumber,
      'phone_number': phoneNumber,
      'token': token,
    };
  }
}
