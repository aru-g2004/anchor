import 'dart:io';
import 'package:anchor/personalization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anchor/profilesetup.dart';

class ProfileViewScreen extends StatelessWidget {
  final String name;
  final String major;
  final String bio;
  final String age;
  final String gender;
  final File? profileImage;

  const ProfileViewScreen({
    super.key,
    required this.name,
    required this.major,
    required this.bio,
    required this.age,
    required this.gender,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final tealColor = Color(0xFF48A6A6);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: tealColor,
        title:
            Text("My Profile", style: GoogleFonts.dmSans(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      backgroundColor: tealColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage:
                    profileImage != null ? FileImage(profileImage!) : null,
                child: profileImage == null
                    ? Icon(Icons.person, size: 60, color: tealColor)
                    : null,
              ),
              SizedBox(height: 20),
              _buildInfoTile(label: "Name", value: name),
              _buildInfoTile(label: "Major", value: major),
              _buildInfoTile(label: "Age", value: age),
              _buildInfoTile(label: "Gender", value: gender),
              _buildInfoTile(label: "Bio", value: bio, maxLines: 5),
              SizedBox(height: 20),

              // Edit Profile Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to Profile Setup Screen with existing data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSetupScreen(
                        initialName: name,
                        initialMajor: major,
                        initialAge: age,
                        initialGender: gender,
                        initialInterests: bio.contains(',')
                            ? bio.split(',').map((tag) => tag.trim()).toList()
                            : [],
                        initialProfileImage: profileImage,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: tealColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text("Edit Profile",
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
              ),

              SizedBox(height: 12),

              // Personalization Button
              OutlinedButton(
                onPressed: () {
                  // Navigate to Personalization Screen with existing data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoiceBioSetupWidget(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text("Customize Experience",
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
              ),

              SizedBox(
                  height: 20), // Add padding at the bottom for better scrolling
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for personalization options
  Widget _buildPreferenceOption(String title) {
    return ListTile(
      title: Text(title, style: GoogleFonts.dmSans()),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.zero,
      dense: true,
      onTap: () {
        // Implementation for each preference type would go here
        // For now, this is just a placeholder
      },
    );
  }

  Widget _buildInfoTile(
      {required String label, required String value, int maxLines = 1}) {
    // Always display Bio as tags
    if (label == "Bio") {
      // If bio is empty, show a placeholder
      if (value.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              "Interests",
              style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "No interests added yet",
                style: GoogleFonts.dmSans(color: Colors.grey[500]),
              ),
            ),
          ],
        );
      }

      // Split the bio into tags
      List<String> tags = [];
      if (value.contains(',')) {
        tags = value
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
      } else {
        // If no commas, treat the whole thing as one tag
        tags = [value.trim()];
      }

      // Categorize tags by type
      List<String> courseTags = tags
          .where((tag) =>
              RegExp(r'^[A-Z]{2,} \d{3}')
                  .hasMatch(tag) || // Matches course codes like CS 251
              tag.contains('Course') ||
              tag.contains('Class'))
          .toList();

      List<String> interestTags = tags
          .where((tag) =>
              !RegExp(r'^[A-Z]{2,} \d{3}').hasMatch(tag) &&
              !tag.contains('Course') &&
              !tag.contains('Class'))
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            "Interests",
            style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (interestTags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interestTags
                        .map((tag) => Chip(
                              label: Text(tag, style: GoogleFonts.dmSans()),
                              backgroundColor: Color(0xFFE0F2F2),
                            ))
                        .toList(),
                  ),
                ],
                if (courseTags.isNotEmpty) ...[
                  if (interestTags.isNotEmpty) SizedBox(height: 12),
                  Text(
                    "Courses",
                    style: GoogleFonts.dmSans(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: courseTags
                        .map((tag) => Chip(
                              label: Text(tag, style: GoogleFonts.dmSans()),
                              backgroundColor:
                                  Color(0xFFE6F0FF), // Light blue for courses
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    // Regular info display for other fields (unchanged)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          label,
          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value.isEmpty ? "Not provided" : value,
            style: GoogleFonts.dmSans(color: Colors.black87),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
