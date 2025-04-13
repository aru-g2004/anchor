import 'package:anchor/bottomnav.dart';
import 'package:anchor/eventpage.dart';
import 'package:anchor/profileview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the Google Fonts package

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Extract the arguments map from the settings
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    // Now you can access individual fields
    final String name = args['name'] ?? 'User';
    final String major = args['major'] ?? '';
    final String bio = args['bio'] ?? '';
    final String age = args['age'] ?? '';
    final String gender = args['gender'] ?? '';
    final profileImage = args['profileImage'];

    return Scaffold(
      backgroundColor: Color(0xFF48A6A6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'images/anchor_logo.png',
                  height: 50,
                  width: 50,
                ),
                Text(
                  'Anchor',
                  style: GoogleFonts.dmSans(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    // Pass extracted arguments to ProfileViewScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileViewScreen(
                          name: name,
                          major: major,
                          bio: bio,
                          age: age,
                          gender: gender,
                          profileImage: profileImage,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Filters (Age, Category, etc.)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilterChip(
                  label: Text('Female-only',
                      style: GoogleFonts.dmSans(color: Colors.black)),
                  backgroundColor: Colors.white,
                  onSelected: (selected) {},
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Sophomores',
                      style: GoogleFonts.dmSans(color: Colors.black)),
                  backgroundColor: Colors.white,
                  onSelected: (selected) {},
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('1-on-1',
                      style: GoogleFonts.dmSans(color: Colors.black)),
                  backgroundColor: Colors.white,
                  onSelected: (selected) {},
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('CS Clubs',
                      style: GoogleFonts.dmSans(color: Colors.black)),
                  backgroundColor: Colors.white,
                  onSelected: (selected) {},
                ),
              ],
            ),
            SizedBox(height: 16),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  hintStyle: GoogleFonts.dmSans(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF48A6A6)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Upcoming Events List
            Expanded(
              child: ListView(
                children: [
                  const EventCard(
                    title: 'CSWN Puzzle Day',
                    location: 'CL50',
                    date: 'April 12th, 2025 10am - 4pm',
                    description:
                        'Join us for a day of puzzles and fun! Test your problem-solving skills, collaborate with friends, and enjoy a variety of challenging activities. Whether you are a puzzle enthusiast or just looking for a fun event, this is the place to be. Don\'t miss out on the excitement!',
                    tags: ['CSWN', 'Puzzles', 'Team Event', 'Prizes'],
                    peopleGoing: ['Alice', 'Bob', 'Charlie'],
                    organizer: 'CSWN',
                  ),
                  const EventCard(
                    title: 'PSUB Self-Care Night',
                    location: 'Purdue Memorial Union',
                    date: 'April 15th, 2025 12pm - 1pm',
                    description: 'Relax and unwind with us!',
                    tags: ['Self-Care', 'Wellness'],
                    peopleGoing: ['David', 'Eve'],
                    organizer: 'PSUB',
                  ),
                  const EventCard(
                    title: 'UR Global Chocoloates Around the World',
                    location: 'Meredith South MPR',
                    date: 'April 18th, 2025 4pm - 5pm',
                    description: 'Explore global chocolate flavors!',
                    tags: ['Chocolate', 'Global'],
                    peopleGoing: ['Frank', 'Grace'],
                    organizer: 'UR Global',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final String description;
  final List<String> tags;
  final List<String> peopleGoing;
  final String organizer;

  const EventCard(
      {required this.title,
      required this.location,
      required this.date,
      required this.description,
      required this.tags,
      required this.peopleGoing,
      required this.organizer});

  @override
  Widget build(BuildContext context) {
    // Helper function to determine icon based on tags or organizer
    IconData getEventIcon() {
      // Check tags first
      if (tags.contains('Puzzles') || tags.contains('Game')) {
        return Icons.extension;
      }
      if (tags.contains('Self-Care') || tags.contains('Wellness')) {
        return Icons.spa;
      }
      if (tags.contains('Chocolate') || tags.contains('Food')) {
        return Icons.restaurant;
      }

      // Check organizer if no matching tags
      switch (organizer) {
        case 'CSWN':
          return Icons.computer;
        case 'PSUB':
          return Icons.event;
        case 'UR Global':
          return Icons.public;
        default:
          return Icons.event_note;
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        // Add leading icon
        leading: CircleAvatar(
          backgroundColor: Color(0xFFE0F2F2),
          child: Icon(getEventIcon(), color: Color(0xFF48A6A6)),
        ),
        title: Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // Rest of the ListTile remains the same
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 5),
            Text(
              date,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward, color: Color(0xFF48A6A6)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(
                  eventName: title,
                  eventDate: date.split(' ')[0],
                  eventTime: date.split(' ')[1] + ' ' + date.split(' ')[2],
                  eventLocation: location,
                  description: description,
                  tags: tags,
                  peopleGoing: peopleGoing,
                  organizer: organizer,
                  flyerUrl: '',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
