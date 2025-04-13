// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EventPage extends StatelessWidget {
//   final String eventName;
//   final String eventDate;
//   final String eventTime;
//   final String eventLocation;
//   final String description;
//   final List<String> tags;
//   final List<String> peopleGoing;
//   final String organizer;
//   final String flyerUrl;

//   const EventPage({
//     required this.eventName,
//     required this.eventDate,
//     required this.eventTime,
//     required this.eventLocation,
//     required this.description,
//     required this.tags,
//     required this.peopleGoing,
//     required this.organizer,
//     required this.flyerUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF48A6A6), // Teal color
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         backgroundColor: Color(0xFF48A6A6),
//         title: Row(
//           children: [
//             Icon(Icons.psychology_alt_outlined, size: 36, color: Colors.white), // Event icon
//             SizedBox(width: 10),
//             Center(
//               child: Text(
//                 eventName,
//                 style: GoogleFonts.dmSans(color: Colors.white, fontSize: 30),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.close, color: Colors.white),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Container under the AppBar with event date/time and location info
//           Container(
//             color: Color(0xFF48A6A6),
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // First row: Date and Time
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text(
//                       '$eventDate at $eventTime',
//                       style: GoogleFonts.dmSans(color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 // Second row: Location info and Open in Maps button
//                 Row(
//                   children: [
//                     Icon(Icons.location_on, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text(
//                       eventLocation,
//                       style: GoogleFonts.dmSans(color: Colors.white),
//                     ),
//                     Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         print("Open maps for $eventLocation");
//                       },
//                       child: Text(
//                         'Open in Maps',
//                         style: GoogleFonts.dmSans(color: Color(0xFF48A6A6)),
//                       ),
//                       style: TextButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 26),

//           // Light green container for the event description
//           Container(
//               color: Color(0xFFF6F7EF), // Light green color
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Text(
//                     description,
//                     style: GoogleFonts.dmSans(
//                         fontWeight: FontWeight.w400,
//                         color: Color.fromARGB(255, 1, 102, 102),
//                         fontSize: 16),
//                   ),
//                   SizedBox(height: 26),

//                   // Row with people going and their avatars
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'People Going',
//                         style: GoogleFonts.dmSans(color: Colors.black),
//                       ),
//                       SizedBox(width: 8),
//                       CircleAvatar(
//                         backgroundImage: AssetImage(
//                             'images/person1.jpg'), // Replace with actual image path
//                       ),
//                       CircleAvatar(
//                         backgroundImage: AssetImage(
//                             'images/person2.jpg'), // Replace with actual image path
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         '+${peopleGoing.length}',
//                         style: GoogleFonts.dmSans(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),

//                   // "Find a Buddy!" button
//                   ElevatedButton(
//                     onPressed: () {
//                       _showMatchFoundDialog(context);
//                     },
//                     child: Text('Find a Buddy!',
//                         style: GoogleFonts.dmSans(
//                             color: Colors.white, fontSize: 20)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color.fromARGB(255, 1, 102, 102),
//                       padding:
//                           EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                   SizedBox(height: 16),

//                   // Button bar with event tags
//                   Center(
//                     child: ButtonBar(
//                       alignment: MainAxisAlignment.start,
//                       children: tags
//                           .map(
//                             (tag) => ElevatedButton(
//                               onPressed: () {},
//                               child: Text(tag),
//                               style: ElevatedButton.styleFrom(
//                                 foregroundColor:
//                                     Color(0xFFF6F7EF), // Light green color
//                                 backgroundColor: Color(0xFF48A6A6),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 8),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ),
//                   SizedBox(height: 16),

//                   // Organizer info section
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundImage: AssetImage(
//                             'images/cswnlogo.png'), // Replace with actual image path
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         'Organized by $organizer',
//                         style: GoogleFonts.dmSans(color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                 ],
//               ))
          
//         ],
//       ),
//     );
//   }

//   void _showMatchFoundDialog(BuildContext context) {
//     final tealColor = Color(0xFF48A6A6);
//     final darkTealColor = Color.fromARGB(255, 1, 102, 102);

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           backgroundColor: darkTealColor,
//           child: Container(
//             padding: EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Match Found!',
//                   style: GoogleFonts.dmSans(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     // Your profile
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.white,
//                           child: Icon(Icons.person, size: 50, color: tealColor),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'You',
//                           style: GoogleFonts.dmSans(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),

//                     // Connection indicator
//                     Container(
//                       width: 40,
//                       child:
//                         Icon(
//                           Icons.bolt_outlined,                          color: Colors.white,
//                           size: 40,
//                         ),
//                       ),
                

//                     // Match profile
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.white,
//                           backgroundImage:
//                               AssetImage('images/placeholder_profile.png'),
//                           child: Icon(Icons.person, size: 50, color: tealColor),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Sarah',
//                           style: GoogleFonts.dmSans(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 32),
//                 Text(
//                   'You both are interested in this event!',
//                   style: GoogleFonts.dmSans(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           // Navigate to chat page
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: darkTealColor,
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         child: Text(
//                           'Start Chatting',
//                           style: GoogleFonts.dmSans(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           // Navigate back to home
//                           // Navigator.pushNamed(context, '/home');
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: darkTealColor,
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         child: Text(
//                           'Explore Events',
//                           style: GoogleFonts.dmSans(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPage extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String description;
  final List<String> tags;
  final List<String> peopleGoing;
  final String organizer;
  final String flyerUrl;

  const EventPage({
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.description,
    required this.tags,
    required this.peopleGoing,
    required this.organizer,
    required this.flyerUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF9acbd0), // Soft background color for a fresh look
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF006a71), // A deeper teal for a modern touch
        title: Row(
          children: [
            Icon(Icons.event, size: 36, color: Colors.white), // Simplified icon
            SizedBox(width: 10),
            Expanded(
              child: Text(
                eventName,
                style: GoogleFonts.dmSans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Date, Time, and Location
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFF006a71), // Consistent teal color
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          '$eventDate at $eventTime',
                          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          eventLocation,
                          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            print("Open maps for $eventLocation");
                          },
                          child: Text(
                            'Open in Maps',
                            style: GoogleFonts.dmSans(color: Color(0xFF006a71)),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Event Description
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFFfafafa), // Light color for contrast
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    Text(
                      description,
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF004d40),
                          fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    // People Going and their avatars
                    Row(
                      children: [
                        Text('People Going', style: GoogleFonts.dmSans(color: Colors.black, fontSize: 16)),
                        SizedBox(width: 8),
                        CircleAvatar(backgroundImage: AssetImage('images/person1.jpg')),
                        CircleAvatar(backgroundImage: AssetImage('images/person2.jpg')),
                        SizedBox(width: 8),
                        Text(
                          '+${peopleGoing.length}',
                          style: GoogleFonts.dmSans(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // "Find a Buddy!" Button
                    ElevatedButton(
                      onPressed: () {
                        _showMatchFoundDialog(context);
                      },
                      child: Text('Find a Buddy!',
                          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF006a71),
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Tags
                    Center(
                      child: ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: tags
                            .map(
                              (tag) => ElevatedButton(
                                onPressed: () {},
                                child: Text(tag, style: GoogleFonts.dmSans(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF006a71),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Organizer info
                    Row(
                      children: [
                        CircleAvatar(backgroundImage: AssetImage('images/cswnlogo.png')),
                        SizedBox(width: 8),
                        Text('Organized by $organizer', style: GoogleFonts.dmSans(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMatchFoundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: Color(0xFF004d40),
          child: Container(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Match Found!',
                  style: GoogleFonts.dmSans(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                         CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('images/person1.jpg'),
                        ),
                        SizedBox(height: 8),
                        Text('You', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Icon(Icons.bolt_outlined, color: Colors.white, size: 40),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('images/person3.jpg'),
                        ),
                        SizedBox(height: 8),
                        Text('Sarah', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'You both are interested in this event!',
                  style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat'); // Navigate to chat page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Start Chatting', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Color(0xFF006a71))),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Explore More Events', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Color(0xFF006a71))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
