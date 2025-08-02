import 'package:flutter/material.dart';
import '../screens/main_menu_screen.dart';

/// A widget that displays the Video Logs screen.
///
/// This screen shows a "VIDEO LOGS" title at the top and a "MAIN MENU" option
/// at the bottom of the screen.
class VideoLogs extends StatelessWidget {
  const VideoLogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Match the background color from the design
      color: const Color.fromRGBO(14, 31, 49, 1),
      // Center the content horizontally
      child: Center(
        child: ConstrainedBox(
          // Set maximum width to match the design
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            width: double.infinity,
            // Apply padding to match the design
            padding: const EdgeInsets.fromLTRB(20, 39, 80, 39),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "VIDEO LOGS" text at the top
                const Text(
                  'VIDEO LOGS',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Spacer to push "MAIN MENU" to the bottom
                const Spacer(),

                // "MAIN MENU" text at the bottom with navigation
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 810),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainMenuScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'MAIN MENU',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
