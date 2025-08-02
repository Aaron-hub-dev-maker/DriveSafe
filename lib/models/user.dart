class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final DateTime lastActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.lastActive,
  });

  // Sample user for demo purposes
  static User sampleUser() {
    return User(
      id: '1',
      name: 'Alex Johnson',
      email: 'alex.johnson@example.com',
      avatarUrl: null, // Will use initials instead
      role: 'Driver',
      lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
    );
  }
}
