import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/menu_item.dart';
import 'drowsiness_log_screen.dart';
import 'yawning_log_screen.dart';
import 'video_logs_screen.dart';
import 'login_screen.dart';

class DriverMonitoringScreen extends StatelessWidget {
  const DriverMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 640;
    final isMediumScreen = screenWidth <= 991;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1F31),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.network(
                "https://cdn.builder.io/api/v1/image/assets/TEMP/b10741dd71442fb068eca439ceb72594187c0668",
                width: isSmallScreen ? screenWidth : 418,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),

              // Menu Items
              _buildMenuItems(context, isSmallScreen, isMediumScreen),

              const Spacer(),

              // Logout Button
              GestureDetector(
                onTap:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "LOG OUT",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems(
    BuildContext context,
    bool isSmallScreen,
    bool isMediumScreen,
  ) {
    final double fontSize = _getResponsiveFontSize(
      isSmallScreen,
      isMediumScreen,
    );

    return Column(
      children: [
        MenuItem(
          title: "DROWSINESS LOG",
          fontSize: fontSize,
          route: '/drowsiness',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DrowsinessLogScreen(),
              ),
            );
          },
        ),
        MenuItem(
          title: "YAWNING LOG",
          fontSize: fontSize,
          route: '/yawning',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const YawningLogScreen()),
            );
          },
        ),
        MenuItem(
          title: "VIDEO LOGS",
          fontSize: fontSize,
          route: '/video_logs',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VideoLogsScreen()),
            );
          },
        ),
      ],
    );
  }

  double _getResponsiveFontSize(bool isSmallScreen, bool isMediumScreen) {
    if (isSmallScreen) return 16;
    if (isMediumScreen) return 18;
    return 20;
  }
}
