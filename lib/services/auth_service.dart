import '../models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService = StorageService();

  // ✅ Login Function
  Future<bool> login(String username, String password) async {
    print("🔍 Checking user: $username");

    User? user = await _storageService.getUser(username);

    if (user == null) {
      print("❌ Username not found: $username");
      return false;
    }

    if (user.password != password) {
      print("❌ Incorrect password for: $username");
      return false;
    }

    print("✅ Login successful for: $username");
    return true;
  }

  // ✅ Register Function
  Future<bool> register(
    String username,
    String email,
    String firstName,
    String lastName,
    String password,
    String licenseNumber,
    String phoneNumber,
  ) async {
    User newUser = User(
      username: username,
      email: email,
      fullName: "$firstName $lastName",
      lastName: lastName,
      password: password,
      licenseNumber: licenseNumber,
      phoneNumber: phoneNumber,
      token: "",
    );

    print("📝 Attempting to register user: $username");
    bool success = await _storageService.saveUser(newUser);

    if (success) {
      print("✅ Registration successful for: $username");
    } else {
      print(
        "❌ Registration failed for: $username (Username might already exist)",
      );
    }

    return success;
  }

  logout() {}
}
