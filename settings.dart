import 'package:anchor/bottomnav.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF48A6A6), // Teal background color
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF48A6A6),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            SizedBox(height: 36),

            // List of settings
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(Icons.account_circle, 'Account'),
                  _buildListTile(Icons.notifications, 'Notifications'),
                  _buildListTile(Icons.lock, 'Privacy'),
                  _buildListTile(Icons.security, 'Security'),
                  _buildListTile(Icons.visibility, 'Appearance'),
                  _buildListTile(Icons.help, 'Help'),
                  _buildListTile(Icons.info, 'About'),
                ],
              ),
            ),
          ],
        ),
      ),
       bottomNavigationBar: BottomNavBar(currentIndex: 2,),
    );
  }

  // Helper function to build each setting item
  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: () {
        // Handle tap if needed
        print('Tapped on $title');
      },
    );
  }
}

