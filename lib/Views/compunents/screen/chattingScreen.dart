import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:talk_app/Views/compunents/personal_chatting/chattingScreen1.dart';
import 'package:talk_app/Views/compunents/personal_chatting/chattingScreen2.dart';
import 'package:talk_app/Views/compunents/personal_chatting/chattingScreen3.dart';
import 'package:talk_app/Views/compunents/personal_chatting/chattingScreen4.dart';
import 'package:talk_app/Views/compunents/personal_chatting/chattingScreen5.dart';
import 'package:talk_app/Views/compunents/personal_chatting/chattingScreen6.dart';
import 'package:talk_app/Views/compunents/personal_chatting/chattingScreen7.dart';
import 'package:talk_app/Views/compunents/personal_chatting/chattingScreen8.dart';

// ✅ Main Chatting Screen with Bottom Navigation
class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  int currentIndex = 0;
  List pages = [
    ProfileScreen(), // ✅ Fixed Naming
    ChattingScreenMain(), // ✅ Fixed Naming
    SettingScreen(), // ✅ Fixed Naming
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatting'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white12,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

// ✅ Fixed Naming for Setting Screen
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Settings Screen"),
    );
  }
}

// ✅ Main Chatting Screen
class ChattingScreenMain extends StatefulWidget {
  @override
  State<ChattingScreenMain> createState() => _ChattingScreenMainState();
}

class _ChattingScreenMainState extends State<ChattingScreenMain> {
  final List<Map<String, dynamic>> contacts = [
    {
      'title': 'John Doe',
      'image': 'assets/images/1 (1).jpeg',
      'page': ChattingScreen1()
    },
    {
      'title': 'Abrar Khan',
      'image': 'assets/images/1 (1).jpg',
      'page': ChattingScreen2()
    },
    {
      'title': 'Salman Khan',
      'image': 'assets/images/1 (2).jpeg',
      'page': ChattingScreen3()
    },
    {
      'title': 'Akram Shah',
      'image': 'assets/images/1 (2).jpg',
      'page': ChattingScreen4()
    },
    {
      'title': 'Bilal Ahmad',
      'image': 'assets/images/1 (3).jpeg',
      'page': ChattingScreen5()
    },
    {
      'title': 'Abbas Afridi',
      'image': 'assets/images/1 (4).jpeg',
      'page': ChattingScreen6()
    },
    {
      'title': 'M.Yamaan',
      'image': 'assets/images/2 (1).jpg',
      'page': ChattingScreen7()
    },
    {
      'title': 'M.Rashid',
      'image': 'assets/images/2 (2).jpg',
      'page': ChattingScreen8()
    },
  ];

  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = List.from(contacts);
  }

  void _searchName(String input) {
    setState(() {
      filteredContacts = contacts
          .where((contact) =>
              contact['title'].toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  final List<String> times = [
    '2:00 AM',
    '4:30 PM',
    '7:10 AM',
    '9:22 AM',
    '9:00 AM',
    '4:33 PM',
    '7:45 AM',
    '10:00 AM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Chat', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _searchName,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(filteredContacts[index]['image'],
                        width: 50, height: 50, fit: BoxFit.cover),
                  ),
                  title: Text(filteredContacts[index]['title'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('What is the condition of the product?'),
                  trailing: Text(times[index % times.length],
                      style: TextStyle(color: Colors.grey)),
                  onTap: () {
                    if (filteredContacts[index]['page'] != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  filteredContacts[index]['page']));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image with error handling
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  // Show options (Gallery or Camera)
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.blue),
              title: Text("Pick from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.green),
              title: Text("Capture from Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.person, size: 80, color: Colors.white)
                      : null,
                ),

                // Camera Button (Inside Profile Image)
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            spreadRadius: 2),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _showImageSourceDialog,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
