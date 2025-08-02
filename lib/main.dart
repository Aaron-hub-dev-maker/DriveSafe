import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/login_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/driver_monitoring_screen.dart';
import 'screens/drowsiness_log_screen.dart';
import 'screens/yawning_log_screen.dart';
import 'screens/video_logs_screen.dart';

void main() {
  runApp(const MyApp());
}

Future<void> requestStoragePermission() async {
  PermissionStatus status = await Permission.storage.request();
  if (status.isGranted) {
    print("✅ Storage permission granted!");
  } else {
    print("❌ Storage permission denied!");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driver Monitoring System',
      theme: ThemeData.dark(),
      initialRoute: '/login', // Set LoginScreen as the starting page
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main_menu': (context) => const MainMenuScreen(),
        '/monitoring': (context) => const DriverMonitoringScreen(),
        '/drowsiness': (context) => const DrowsinessLogScreen(),
        '/yawning': (context) => const YawningLogScreen(),
        '/video_logs': (context) => const VideoLogsScreen(),
      },
    );
  }
}
