import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'driver_monitoring_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final User? user;

  const MainMenuScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes back arrow
        title: Row(
          children: [
            Image.asset(
              "assets/smalllogo.png", // Updated image
              height: 40, // Adjusted size
            ),
            const SizedBox(width: 10),
            const Text(
              'Main Menu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0.7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF15376E), // Updated background color
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome, ${user?.fullName ?? 'User'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32), // Increased spacing
              // Buttons with matching color and size
              _buildMenuOption(
                context,
                'Driver Monitoring',
                Icons.car_repair,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DriverMonitoringScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Uniform spacing
              _buildMenuOption(context, 'Logout', Icons.logout, () async {
                await AuthService().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 200, // Ensuring equal width for buttons
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.blueGrey.shade700, // Matching background color
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
