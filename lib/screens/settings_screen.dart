import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';
import '../widgets/user_avatar.dart';

class SettingsScreen extends StatelessWidget {
  final User user;

  const SettingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1F31),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'SETTINGS',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile section
              Center(
                child: Column(
                  children: [
                    UserAvatar(user: user, size: 80),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4400FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.role,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4400FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Settings sections
              _buildSectionTitle('Account'),
              _buildSettingItem(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.notifications_none,
                title: 'Notifications',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: 'Privacy & Security',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Preferences'),
              _buildSettingItem(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English (US)',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                hasSwitch: true,
                switchValue: true,
                onSwitchChanged: (value) {},
              ),
              _buildSettingItem(
                icon: Icons.notifications_active_outlined,
                title: 'Alert Sounds',
                hasSwitch: true,
                switchValue: true,
                onSwitchChanged: (value) {},
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Support'),
              _buildSettingItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {},
              ),

              const SizedBox(height: 40),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade300,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool hasSwitch = false,
    bool switchValue = false,
    Function(bool)? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: hasSwitch ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4400FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF4400FF), size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                if (hasSwitch)
                  Switch(
                    value: switchValue,
                    onChanged: onSwitchChanged,
                    activeColor: const Color(0xFF4400FF),
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
