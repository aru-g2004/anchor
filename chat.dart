import 'package:anchor/bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String matchName;
  final String matchImageUrl;
  final String eventName;
  final String eventDescription;
  final String eventDate;
  final String eventLocation;

  const ChatPage({
    Key? key, 
    this.matchName = "Sarah",
    this.matchImageUrl = "",
    this.eventName = "CSWN Puzzle Day",
    this.eventDescription = "Collaborative puzzle solving event!",
    this.eventDate = "April 12th, 2025",
    this.eventLocation = "CL50",
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // List of messages (for demonstration)
  final List<Map<String, dynamic>> messages = [
    {"sender": "user", "text": "Hey! How are you?"},
    {"sender": "matched", "text": "I'm good, thanks! How about you?"},
    {"sender": "user", "text": "I'm doing great!"},
    {"sender": "matched", "text": "Are you going to the event today?"},
    {"sender": "user", "text": "Yes! I'm excited about it. What time are you planning to arrive?"},
  ];

  // Controller for the message input field
  final TextEditingController _controller = TextEditingController();
  
  // Event card expanded state
  bool _isEventCardExpanded = true;

  // Function to send message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({
          "sender": "user",
          "text": _controller.text,
        });
        _controller.clear(); // Clear input field after sending
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tealColor = Color(0xFF48A6A6);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tealColor,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: 10),
                                   CircleAvatar(backgroundImage: AssetImage('images/person3.jpg')),

            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.matchName,
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Online",
                  style: GoogleFonts.dmSans(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              setState(() {
                _isEventCardExpanded = !_isEventCardExpanded;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Event Card
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isEventCardExpanded ? 100 : 0,
            child: _isEventCardExpanded ? Card(
              margin: EdgeInsets.all(8),
              color: Color(0xFFE0F2F2),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event, color: tealColor, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Attending: ${widget.eventName}",
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.bold,
                            color: tealColor,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isEventCardExpanded = false;
                            });
                          },
                          child: Icon(Icons.close, size: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      widget.eventDescription,
                      style: GoogleFonts.dmSans(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${widget.eventDate} • ${widget.eventLocation}",
                      style: GoogleFonts.dmSans(
                        fontSize: 12, 
                        color: Colors.black54,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ) : Container(),
          ),
          
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              reverse: true, // Show latest message at the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final messageIndex = messages.length - 1 - index;
                final message = messages[messageIndex];
                final isUser = message['sender'] == 'user';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          backgroundImage: widget.matchImageUrl.isNotEmpty 
                              ? NetworkImage(widget.matchImageUrl) 
                              : null,
                          child: widget.matchImageUrl.isEmpty
                              ? Icon(Icons.person, color: tealColor, size: 16)
                              : null,
                        ),
                        SizedBox(width: 8),
                      ],
                      
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isUser ? tealColor : Colors.grey[200],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          child: Text(
                            message['text'],
                            style: GoogleFonts.dmSans(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      
                      if (isUser) ...[
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: tealColor,
                          child: Icon(Icons.person, color: Colors.white, size: 16),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Input Field and Send Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      hintStyle: GoogleFonts.dmSans(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: tealColor,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
       bottomNavigationBar: BottomNavBar(currentIndex: 1,),
    );
  }
}