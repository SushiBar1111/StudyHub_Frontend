import 'package:flutter/material.dart';
import 'package:learn_hub/pages/chatlist_page.dart';
import 'package:learn_hub/pages/login_page.dart';
import 'package:learn_hub/pages/search_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            'lib/images/Study Hub Logo.png',
            height: 40,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // Kotak hijau bertuliskan "Settings"
          Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Center(
              child: Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Kotak "StudyHub Premium" yang lebih besar dan bisa dipencet
          GestureDetector(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'StudyHub\n',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Premium',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.amber, // Warna emas
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children: const [
                _SingleSection(
                  title: "Account Settings",
                  fontFamily: 'OpenSans',
                  children: [
                    _CustomListTile(
                      title: "Account",
                      icon: Icons.person,
                      fontFamily: 'OpenSans',
                    ),
                    _CustomListTile(
                      title: "Privacy & Security",
                      icon: Icons.lock,
                      fontFamily: 'OpenSans',
                    ),
                    _CustomListTile(
                      title: "Premium",
                      icon: Icons.workspace_premium_rounded,
                      fontFamily: 'OpenSans',
                    ),
                  ],
                ),
                _SingleSection(
                  title: "App Settings",
                  fontFamily: 'OpenSans',
                  children: [
                    _CustomListTile(
                      title: "Notification",
                      icon: Icons.notifications,
                      fontFamily: 'OpenSans',
                    ),
                    _CustomListTile(
                      title: "Chats",
                      icon: Icons.chat,
                      fontFamily: 'OpenSans',
                    ),
                    _CustomListTile(
                      title: "Language",
                      icon: Icons.language_rounded,
                      fontFamily: 'OpenSans',
                    ),
                  ],
                ),
                _SingleSection(
                  title: "Support",
                  fontFamily: 'OpenSans',
                  children: [
                    _CustomListTile(
                      title: "Support",
                      icon: Icons.support_agent_rounded,
                      fontFamily: 'OpenSans',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tombol Logout di bagian paling bawah layar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Adjusted padding for a smaller button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // More rounded corners
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  "Log out",
                  style: TextStyle(
                    fontSize: 16, // Reduced font size
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        currentIndex: 2, // Set to 2 to highlight the "Settings" icon as active
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontSize: 0), // Hide label
        unselectedLabelStyle: const TextStyle(fontSize: 0), // Hide label
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Colors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black26, // Warna latar belakang redup
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.settings, color: Colors.white),
            ),
            label: '',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatListPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
        },
      ),
    );
  }
}

// Widget untuk membuat bagian pengaturan
class _SingleSection extends StatelessWidget {
  final String title;
  final String fontFamily;
  final List<Widget> children;

  const _SingleSection({
    required this.title,
    required this.fontFamily,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// Widget untuk setiap item dalam daftar pengaturan
class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String fontFamily;

  const _CustomListTile({
    required this.title,
    required this.icon,
    required this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.green),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: fontFamily,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          onTap: () {
            // Tambahkan fungsi navigasi atau aksi yang sesuai
          },
        ),
        const Divider(color: Colors.black26, thickness: 1), // Garis bawah tipis
      ],
    );
  }
}
