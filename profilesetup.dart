import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anchor/profileview.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key, required String initialMajor, required String initialName, required String initialAge, required String initialGender, required List initialInterests, File? initialProfileImage});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  // Controllers for text fields
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final majorController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // For image picking
  File? _profileImage;
  final picker = ImagePicker();

  // List of selected interests/tags
  final List<String> selectedInterests = [];

  // Available interest options
  final List<String> interestOptions = [
    'Reading',
    'Gaming',
    'Sports',
    'Music',
    'Art',
    'Technology',
    'Cooking',
    'Travel',
    'Photography',
    'Dance',
    'Movies',
    'Hiking',
    'Writing',
    'Fashion',
    'Fitness',
    'Programming',
    'Swimming',
    'Volunteering'
  ];

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // For desktop compatibility, use a file picker package like `file_picker`
      // if the platform is not supported by `image_picker`.
      if (e.toString().contains('Unsupported operation')) {
        final result = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
        ); 
        if (result != null) {
          setState(() {
            _profileImage = File(result.path);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    majorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tealColor = Color(0xFF48A6A6);

    return Scaffold(
      backgroundColor: tealColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Profile Setup",
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Profile Image Section with Upload
                  Stack(
                    children: [
                      // Profile image or placeholder
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 60, color: tealColor)
                            : null,
                      ),
                      // Camera icon to change image
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt,
                                color: tealColor, size: 20),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildTextField(
                      label: "Name",
                      controller: nameController,
                      isRequired: true),
                  SizedBox(height: 16),
                  _buildDropdownField(label: "Degree Type", items: [
                    'Undergraduate',
                    'Graduate',
                    'PhD',
                    'Postdoc',
                  ]),
                  SizedBox(height: 16),
                  _buildDropdownField(label: "Year", items: [
                    'Freshman',
                    'Sophomore',
                    'Junior',
                    'Senior',
                  ]),
               _buildDropdownField(label: "Gender", items: [
                   'Female', 
                   'Male', 
                   'Transgender',
                   'Genderqueer',
                   'Genderfluid',
                    'Agender',
                   'Non-binary',
                   'Prefer not to say'
                  ]),
                  Row(
                    children: [
                     Expanded(child: _buildTextField(label: "Major", controller: majorController)),

                      SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                            label: "Age",
                            controller: ageController,
                            keyboardType: TextInputType.number),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Interest Tags Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Interests",
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Container for selectable tags
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: interestOptions.map((interest) {
                        final isSelected = selectedInterests.contains(interest);
                        return FilterChip(
                          label: Text(
                            interest,
                            style: GoogleFonts.dmSans(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedInterests.add(interest);
                              } else {
                                selectedInterests.remove(interest);
                              }
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: tealColor,
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Join selected interests into a single string
                        final bioTags = selectedInterests.join(', ');

                        Navigator.pushNamed(
                          context,
                          '/home',
                            arguments: {
                            'name': nameController.text,
                            'major': majorController.text,
                            'bio': bioTags,
                            'age': ageController.text,
                            'gender': genderController.text,
                            'profileImage': _profileImage,
                            },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: tealColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      {required String label, List<String> items = const []}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 18),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(border: InputBorder.none),
            value: null,
            hint: Text("Select $label"),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: GoogleFonts.dmSans()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Handle the selected value
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 18),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.dmSans(),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your $label';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
