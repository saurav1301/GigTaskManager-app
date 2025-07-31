import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C91F9),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/images/profile_placeholder.png',
              ), // Add your profile image asset
            ),
            const SizedBox(height: 20),
            const Text(
              'Saurav Negi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'saurav.negi1301@gmail.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            profileOption(Icons.person, 'Edit Profile', () {}),
            profileOption(Icons.lock, 'Change Password', () {}),
            profileOption(Icons.settings, 'Settings', () {}),
            profileOption(Icons.logout, 'Logout', () {
              // Implement logout functionality
            }),
          ],
        ),
      ),
    );
  }

  Widget profileOption(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
