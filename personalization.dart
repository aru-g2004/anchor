import 'dart:io';
import 'dart:math';
import 'package:anchor/profileview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class VoiceBioSetupWidget extends StatefulWidget {
  @override
  _VoiceBioSetupWidgetState createState() => _VoiceBioSetupWidgetState();
}

class _VoiceBioSetupWidgetState extends State<VoiceBioSetupWidget> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _transcribedText = '';
  List<String> _tags = [];
  List<String> _courseTags = []; // New list for course tags
  String _bio = '';
  bool _isGeneratingTags = false;
  bool _isProcessingSchedule = false; // New state for schedule processing

  // For image picking
  final ImagePicker _picker = ImagePicker();
  File? _scheduleImage;
  Uint8List? _webScheduleImage;

  // Your Gemini API key - replace with your actual API key
  static const apiKey = 'AIzaSyA5jS--eMWpzc4wTLZy7yy15eEkkjQEXzM';
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();

    // Initialize the Gemini model
    _model = GenerativeModel(
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 100,
        topP: 0.9,
        topK: 40,
      ),
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
    );
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (!available) {
      print('Speech recognition not available');
    }
  }

  void _startListening() async {
    await _speech.listen(onResult: _onSpeechResult);
    setState(() => _isListening = true);
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);

    // Now use Gemini to generate tags
    if (_transcribedText.isNotEmpty) {
      _generateTagsWithGemini();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _transcribedText = result.recognizedWords;
    });
  }

  // Update the _pickScheduleImage method to handle image validation better
  Future<void> _pickScheduleImage() async {
    try {
      // Allow user to pick an image with specific allowed formats
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85, // Balance quality and performance
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          try {
            // Load and validate the image bytes
            final Uint8List imageBytes = await pickedFile.readAsBytes();

            // Basic validation: check if image has reasonable size
            if (imageBytes.length < 100) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Invalid image file. Please select a different image.')));
              return;
            }

            setState(() {
              _webScheduleImage = imageBytes;
              _scheduleImage = null;
            });

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Schedule image uploaded successfully!')));
            // Process the schedule image
            _processScheduleImage();
          } catch (e) {
            print('Error processing image: $e');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Failed to process the image. Please try another image format like JPEG or PNG.')));
          }
        } else {
          // Mobile implementation
          setState(() {
            _scheduleImage = File(pickedFile.path);
            _webScheduleImage = null;
          });
          // Process the schedule image
          _processScheduleImage();
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image. Please try again.')));
    }
  }

  // Process the schedule image with Gemini
  Future<void> _processScheduleImage() async {
    if (_scheduleImage == null && _webScheduleImage == null) return;

    setState(() => _isProcessingSchedule = true);

    try {
      // Prepare the image data for Gemini
      final imageData =
          _webScheduleImage ?? await _scheduleImage!.readAsBytes();

      // Create a prompt for Gemini to extract course codes
      const prompt = '''
Look at this image of a class schedule and extract all course codes and names.
Return ONLY the course codes and names as a comma-separated list (e.g., "CS 251, ECON 251, MATH 161").
If you can't identify any course codes, respond with "No courses identified".
''';

      // Use the correct format to send both text and image to Gemini
      Iterable<Content> content = [
        Content.text(prompt),
        Content.data('image/jpeg', imageData)
      ];

      // Generate content with the image
      final response = await _model.generateContent(content);

      final courseText = response.text?.trim() ?? '';
      print('Gemini extracted courses: $courseText');

      // Process response...
      if (courseText.isNotEmpty && courseText != "No courses identified") {
        final newCourseTags = courseText
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
        setState(() {
          _courseTags = newCourseTags;
        });
      } else {
        setState(() {
          _courseTags = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'No course codes identified in the image. Try a clearer image.')));
      }
    } catch (e) {
      print('Error processing schedule with Gemini: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Error analyzing schedule: ${e.toString().substring(0, min(100, e.toString().length))}')));
    } finally {
      setState(() => _isProcessingSchedule = false);
    }
  }

  Future<void> _generateTagsWithGemini() async {
    if (_transcribedText.isEmpty) return;
    try {
      setState(() => _isGeneratingTags = true);
      // Craft a prompt that asks Gemini to extract tags
      final prompt = '''
Extract interest tags from the following text for example "Badminton, Foodie, Tech Enthusiast". 
Return ONLY the tags as a comma-separated list with no additional text.
The tags should be single words or short phrases that represent hobbies, interests, or characteristics.

Text: $_transcribedText
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      final tagText = response.text?.trim() ?? '';
      print('Gemini generated tags: $tagText');

      if (tagText.isNotEmpty) {
        final newTags = tagText
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
        setState(() {
          _tags = newTags;
        });
      }
    } catch (e) {
      print('Error generating tags with Gemini: $e');
      // Fallback to simple extraction if Gemini fails
      setState(() {
        _tags = _extractTagsSimple(_transcribedText);
      });
    } finally {
      setState(() => _isGeneratingTags = false);
    }
  }

  // Keep the simple extraction as a fallback
  List<String> _extractTagsSimple(String text) {
    final stopWords = [
      'i',
      'like',
      'to',
      'and',
      'the',
      'a',
      'my',
      'with',
      'of',
      'in',
      'for',
      'about'
    ];
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(' ')
        .where((w) => !stopWords.contains(w) && w.length > 2)
        .toSet()
        .toList();
    return words;
  }

  void _addTagToBio(String tag) {
    setState(() {
      if (!_bio.contains(tag)) {
        _bio += (_bio.isEmpty ? '' : ', ') + tag;
      }
    });
  }

  Widget _buildImagePreview() {
    if (_scheduleImage != null) {
      // Mobile image preview
      return Image.file(
        _scheduleImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error rendering image: $error');
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.red[300], size: 40),
              SizedBox(height: 4),
              Text('Image could not be displayed',
                  style: GoogleFonts.dmSans(color: Colors.red[300])),
            ],
          );
        },
      );
    } else if (_webScheduleImage != null) {
      // Web image preview with error handling
      return Image.memory(
        _webScheduleImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error rendering web image: $error');
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.red[300], size: 40),
              SizedBox(height: 4),
              Text('Image could not be displayed',
                  style: GoogleFonts.dmSans(color: Colors.red[300])),
            ],
          );
        },
      );
    } else {
      // Default placeholder
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_file, color: Colors.grey[600], size: 40),
          SizedBox(height: 8),
          Text('Tap to upload schedule',
              style: GoogleFonts.dmSans(color: Colors.grey[600])),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tealColor = Color(0xFF48A6A6);

    return Scaffold(
      appBar: AppBar(
         actions: [IconButton(
           icon: Icon(Icons.arrow_back, color: Colors.white),
           onPressed: () {
             Navigator.pop(context);
           },
         ),]
      ),
      backgroundColor: tealColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text('Personalize Your Profile',
                  style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white)),
              SizedBox(height: 15),
              Text(
                'Want to personalize your profile without the hassle?',
                textAlign: TextAlign.left,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24),

              // Voice recording section - more compact design
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Talk about yourself',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: tealColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Just ramble about your interests (I like playing trying new foods, playing tennis....) - no typing needed!',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: _isListening ? Colors.red[50] : Color(0xFFE0F2F2),
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: _isListening ? _stopListening : _startListening,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            _isListening ? Icons.stop_circle : Icons.mic,
                            color: _isListening ? Colors.red : tealColor,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Schedule upload section - simplified without preview
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload your class schedule',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: tealColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Snap a pic of your class schedule - we\'ll take it from there!',
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (_courseTags.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${_courseTags.length} courses found',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickScheduleImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tealColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text('Upload',
                          style: GoogleFonts.dmSans(fontSize: 14)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Generated tags section
              if (_isGeneratingTags || _isProcessingSchedule)
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 12),
                      Text(
                        'Processing...',
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_tags.isNotEmpty || _courseTags.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select tags to add to your bio:',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: tealColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      if (_tags.isNotEmpty) ...[
                        Text('Interests:',
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _tags
                              .map((tag) => ActionChip(
                                    label:
                                        Text(tag, style: GoogleFonts.dmSans()),
                                    onPressed: () => _addTagToBio(tag),
                                    backgroundColor: Color(0xFFE0F2F2),
                                    avatar: Icon(Icons.add,
                                        size: 18, color: tealColor),
                                  ))
                              .toList(),
                        ),
                      ],
                      if (_courseTags.isNotEmpty) ...[
                        SizedBox(height: 16),
                        Text('Courses:',
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _courseTags
                              .map((course) => ActionChip(
                                    label: Text(course,
                                        style: GoogleFonts.dmSans()),
                                    onPressed: () => _addTagToBio(course),
                                    backgroundColor: Color(0xFFE6F0FF),
                                    avatar: Icon(Icons.add,
                                        size: 18, color: Colors.blue),
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),

              SizedBox(height: 24),

              // Bio field
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Bio',
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tealColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: TextEditingController(text: _bio),
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            'Tap on tags above to add them to your bio...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        fillColor: Color(0xFFF5F5F5),
                        filled: true,
                      ),
                      style: GoogleFonts.dmSans(),
                      onChanged: (val) => _bio = val,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Continue button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Check if we have any tags to add
                    if (_bio.isNotEmpty) {
                      // Navigate to ProfileViewScreen with the updated bio
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileViewScreen(
                            name:
                                "Your Name", // Replace with actual stored name
                            major:
                                "Your Major", // Replace with actual stored major
                            age: "Your Age", // Replace with actual stored age
                            gender:
                                "Your Gender", // Replace with actual stored gender
                            bio: _bio, // Pass the bio with tags
                            profileImage:
                                null, // Pass the profile image if you have it
                          ),
                        ),
                      );
                    } else {
                      // Show a message if no tags are selected
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Please select at least one tag to continue')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: tealColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text('Continue',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
