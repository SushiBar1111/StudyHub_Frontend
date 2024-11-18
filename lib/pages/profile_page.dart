import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePageContent extends StatefulWidget {
  const ProfilePageContent({super.key});

  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  String? selectedRole;
  String? selectedSubjects;
  String? userId;
  String? selectedGender;
  String? selectedAcademicLevel;
  String? selectedLearningType;
  String? selectedStudyPlace;
  String? _profilePicturePath;

  final List<String> roles = [
    "A Study Mate",
    "Someone To Teach",
    "Someone To Learn",
  ];

  final List<String> subjects = [
    "Math",
    "Biology",
    "Coding",
    "Physics",
    "Literature",
    "Law",
    "Accounting"
  ];

  final List<String> genders = ["Male", "Female", "Other"];

  final List<String> learningTypes = [
    "Visual Learner",
    "Read/Write Learner",
    "Auditory Learner",
    "Kinesthetic Learner",
    "Solitary Learner",
    "Naturalistic Learner",
    "Social Learner",
  ];

  final List<String> studyPlaces = [
    "Cafe",
    "Library",
    "Park",
    "Video Call",
    "Call"
  ];

  final List<String> academicLevels = [
    "Senior High School",
    "Undergraduate",
    "Master",
    "Doctorate",
    "Employee",
  ];

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  final learningTypeController = TextEditingController();
  final studyPlaceController = TextEditingController();
  final academicLevelController = TextEditingController();

  File? _image;

  final ImagePicker _picker = ImagePicker();
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    userId = await storage.read(key: 'id');
    if (userId != null) {
      getUserData(userId!);
    }
  }

  ImageProvider _imageFromFilePath(String? filePath) {
    if (filePath == null) {
      return const NetworkImage(
          'https://cdn.pixabay.com/photo/2023/08/24/19/58/saitama-8211499_1280.png');
    } else {
      return NetworkImage('http://10.0.2.2:8000/$filePath');
    }
  }

  Future<void> getUserData(String userId) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/profile?id=$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nameController.text = data['first_name'];
        emailController.text = data['email'];
        selectedRole = data['role'];
        selectedSubjects = data['matkul'];
        _profilePicturePath = data['profilePicture'];
        selectedGender = data['gender'];
        locationController.text = data['location'];
        bioController.text = data['bio'];
        selectedLearningType = data['learningType'];
        selectedStudyPlace = data['studyPlace'];
        selectedAcademicLevel = data['academicLevel'];
      });
    } else {
      print("No user data");
    }
  }

  Future<void> updateUserData() async {
    if (_image != null) {
      await uploadImage(_image!);
    }
    final response = await http.patch(
      Uri.parse('http://10.0.2.2:8000/updateProfile/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': userId,
        'first_name': nameController.text,
        'email': emailController.text,
        'role': selectedRole,
        'matkul': selectedSubjects,
        'gender': selectedGender,
        'location': locationController.text,
        'bio': bioController.text,
        'learningType': selectedLearningType,
        'studyPlace': selectedStudyPlace,
        'academicLevel': selectedAcademicLevel,
      }),
    );

    if (response.statusCode == 200) {
      getUserId();
    } else {
      print("Failed to update user data");
    }
  }

  Future<void> getImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadImage(File image) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/profileImage/upload/'));
    request.files.add(
        await http.MultipartFile.fromPath('profilePicture', image.path));
    request.fields['id'] = userId ?? '';

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded');
    } else {
      print('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back button
        title: ListTile(
          contentPadding: EdgeInsets.zero, // Remove default padding
          leading: Image.asset(
            'lib/images/Study Hub Logo.png', // Path to your "Study Hub" logo
            height: 40, // Adjust as needed
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0x005f5f5f),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            // Menambahkan padding di seluruh tepi
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  // Pastikan ini mengisi lebar penuh
                  color: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  // Padding vertikal
                  margin: EdgeInsets.zero,
                  // Tidak ada margin
                  child: const Text(
                    "My Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFromFilePath(_profilePicturePath),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: getImage,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Saitama",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.green,
                      fontFamily: 'OpenSans'),
                ),
                const SizedBox(height: 10),
                _buildTextField("Name :", nameController),
                const SizedBox(height: 10),
                _buildTextField("E-mail :", emailController),
                const SizedBox(height: 10),
                _buildDropdown("Role :", roles, selectedRole, (value) {
                  setState(() {
                    selectedRole = value;
                  });
                }),
                const SizedBox(height: 10),
                _buildDropdown("I am learning this subject :", subjects,
                    selectedSubjects, (value) {
                      setState(() {
                        selectedSubjects = value;
                      });
                    }),
                const SizedBox(height: 10),
                _buildDropdown("Gender :", genders, selectedGender, (value) {
                  setState(() {
                    selectedGender = value;
                  });
                }),
                const SizedBox(height: 10),
                _buildTextField("Location :", locationController),
                const SizedBox(height: 10),
                _buildTextField("Bio :", bioController),
                const SizedBox(height: 10),
                _buildDropdown(
                    "My Learning Type :", learningTypes, selectedLearningType, (
                    value) {
                  setState(() {
                    selectedLearningType = value;
                  });
                }),
                const SizedBox(height: 10),
                _buildDropdown("Preferred Study Place :", studyPlaces,
                    selectedStudyPlace, (value) {
                      setState(() {
                        selectedStudyPlace = value;
                      });
                    }),
                const SizedBox(height: 10),
                _buildDropdown(
                    "Academic Level :", academicLevels, selectedAcademicLevel, (
                    value) {
                  setState(() {
                    selectedAcademicLevel = value;
                  });
                }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors
                            .green, // Warna hijau untuk tombol "Cancel"
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors
                            .green, // Warna hijau untuk tombol "Save"
                      ),
                      onPressed: updateUserData,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
                vertical: 10.0), // Menambahkan padding di dalam TextField
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
                vertical: 10.0), // Menambahkan padding di dalam Dropdown
          ),
          value: selectedValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}