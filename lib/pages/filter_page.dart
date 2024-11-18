import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final storage = const FlutterSecureStorage();
  final genderController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  final learningTypeController = TextEditingController();
  final studyPlaceController = TextEditingController();
  final academicLevelController = TextEditingController();
  final ageController = TextEditingController();

  String? selectedRole;
  String? selectedSubjects;
  String? userId;
  String? selectedGender;
  String? selectedAcademicLevel;
  String? selectedLearningType;
  String? selectedStudyPlace;

  Future<void> userFilter() async {
    userId = await storage.read(key: 'id');
    if (userId != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/filter/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': userId,
          'preferences': [
            {
              'gender': selectedGender,
              'role': selectedRole,
              'matkul': selectedSubjects,
              'academicLevel': selectedAcademicLevel,
              'studyPlace': selectedStudyPlace,
              'learningType': selectedLearningType,
            },
          ],
        }),
      );
      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);

        final prefs = await SharedPreferences.getInstance();

        final userPreferences = jsonData['preferences'] as List;
        for (var preference in userPreferences) {
          final role = preference['role'];
          final gender = preference['gender'];
          final academicLevel = preference['academicLevel'];
          final studyPlace = preference['studyPlace'];
          final learningType = preference['learningType'];
          final matkul = preference['matkul'];

          prefs.setString('role', role);
          prefs.setString('gender', gender);
          prefs.setString('academicLevel', academicLevel);
          prefs.setString('studyPlace', studyPlace);
          prefs.setString('learningType', learningType);
          prefs.setString('matkul', matkul);
        }
      } else {
        print('Error saving user preferences: ${response.statusCode}');
        print(response.body);
      }
    }
  }

  final List<String> academicLevels = [
    'Senior High School',
    'Undergraduate',
    'Master',
    'Doctorate',
    'Employee',
  ];

  final List<String> roles = [
    "A Study Mate",
    "Someone to Teach",
    "Someone to Learn",
  ];

  final List<String> subjects = [
    "Math", "Biology", "Coding", "Physics", "Literature", "Law", "Accounting"
  ];

  final List<String> Gender = [
    "Male", "Female", "Other"
  ];

  final List<String> StudyPlace = [
    "Cafe", "Library", "Park", "Video Call", "Call"
  ];

  final List<String> LearningType = [
    "Visual Learner", "Read/Write Learner", "Auditory Learner", "Kinesthetic Learner", "Solitary Learner", "Naturalistic Learner", "Social Learner"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filter Page',
          style: TextStyle(
            color: Colors.green,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        leading: const Icon(
          color: Colors.black,
          Icons.filter_alt_rounded,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set Your Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                "Academic Level",
                academicLevels,
                selectedAcademicLevel,
                    (value) => setState(() {
                  selectedAcademicLevel = value;
                }),
              ),
              const SizedBox(height: 15),
              _buildDropdown(
                "Role",
                roles,
                selectedRole,
                    (value) => setState(() {
                  selectedRole = value;
                }),
              ),
              const SizedBox(height: 15),
              _buildDropdown(
                "Subjects",
                subjects,
                selectedSubjects,
                    (value) => setState(() {
                  selectedSubjects = value;
                }),
              ),
              const SizedBox(height: 15),
              _buildDropdown(
                "Gender",
                Gender,
                selectedGender,
                    (value) => setState(() {
                  selectedGender = value;
                }),
              ),
              const SizedBox(height: 15),
              _buildDropdown(
                "Study Place",
                StudyPlace,
                selectedStudyPlace,
                    (value) => setState(() {
                  selectedStudyPlace = value;
                }),
              ),
              const SizedBox(height: 15),
              _buildDropdown(
                "Learning Type",
                LearningType,
                selectedLearningType,
                    (value) => setState(() {
                  selectedLearningType = value;
                }),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel button functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300], // Light grey
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Green text color
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: userFilter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300], // Light grey
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Green text color
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black.withOpacity(0.3), // Reduced opacity
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(6.0),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.school, color: Colors.white),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: '',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/chatlist');
              break;
            case 1:
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedItem,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: DropdownButton<String>(
            value: selectedItem,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: Colors.grey[200],
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}