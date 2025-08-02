import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({super.key, required this.user, this.size = 40, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF4400FF).withOpacity(0.2),
          border: Border.all(color: const Color(0xFF4400FF), width: 2),
        ),
        child:
            user.avatarUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(size / 2),
                  child: Image.network(user.avatarUrl!, fit: BoxFit.cover),
                )
                : Center(
                  child: Text(
                    _getInitials(user.name),
                    style: GoogleFonts.inter(
                      color: const Color(0xFF4400FF),
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
      ),
    );
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}';
    } else if (name.isNotEmpty) {
      return name[0];
    }
    return '';
  }
}
