import 'package:flutter/material.dart';
import 'package:learn_hub/pages/profile_page.dart';
import 'package:learn_hub/pages/chatlist_page.dart';
import 'package:learn_hub/pages/settings_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _currentPageIndex = 0; // For tracking current image index
  bool _showMoreDescription = false; // Toggle to show more description
  final int _selectedIconIndex = 1; // Track selected icon (0 for chat, 1 for toga, 2 for settings)

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
          title: const Text(
            'Search',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        centerTitle: false, // Align the title and logo to the left
        actions: [
          // Profile Icon that directs to ProfilePage
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2023/08/24/19/58/saitama-8211499_1280.png'),
              radius: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePageContent()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Search box with inbox icon on the right
          Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10), // Left padding
                const Text(
                  "Search",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.inbox, color: Colors.white),
                  onPressed: () {
                    // Implement inbox functionality
                  },
                ),
              ],
            ),
          ),

          // Image Swiper
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  itemCount: 2, // Two images for demonstration
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset('lib/images/jiwon.png', fit: BoxFit.cover, width: double.infinity);
                  },
                ),

                // Dots indicator in the middle bottom
                Positioned(
                  bottom: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 2; i++)
                        Container(
                          margin: const EdgeInsets.all(4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _currentPageIndex ? Colors.green : Colors.grey,
                          ),
                        )
                    ],
                  ),
                ),

                // "+" Button in the bottom right with circle background
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      // Action when the button is pressed
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),

                // Description in bottom left of image without background
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Kim Ji Won, 32 years", style: TextStyle(color: Colors.white)),
                      const Text("Bachelors", style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showMoreDescription = !_showMoreDescription;
                          });
                        },
                        child: Text(
                          _showMoreDescription ? "Hide description" : "...",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (_showMoreDescription)
                        const Text(
                          "Frieren is a long-living character who has traveled far and wide...",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom navigation bar with message, toga, and settings icon
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        currentIndex: 1, // Set to 1 to highlight the "school" icon as active
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
                color: Colors.black26, // Background color dimmed for the active "school" icon
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
                color: Colors.transparent,
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
