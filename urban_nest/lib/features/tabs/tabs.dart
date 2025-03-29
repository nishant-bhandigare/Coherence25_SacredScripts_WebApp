import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_nest/features/community/community_page.dart';
import 'package:urban_nest/features/drawer/drawer.dart';
import 'package:urban_nest/features/home/home_page.dart';
import 'package:urban_nest/features/profile/profile_page.dart';
import 'package:urban_nest/features/search/search_page.dart';
import 'package:urban_nest/theme_notifier.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const CommunityPage(),
    const ProfilePage(),
  ];

  final List<IconData> _icons = [
    Icons.home_filled,
    Icons.search,
    Icons.supervisor_account,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeNotifier>(context).getTheme();
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      drawer: const DrawerScreen(),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            bottom: 20, // Adjust this value for more floating effect
            left: MediaQuery.of(context).size.width * 0.1, // Centering it
            right: MediaQuery.of(context).size.width * 0.1, // Centering it
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_icons.length, (index) {
                  bool isSelected = index == _selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _icons[index],
                          size: 28,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                        if (isSelected)
                          Container(
                            width: 20,
                            height: 3,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= PAGES =======================

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Chat Page",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}


class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "History Page",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Notifications Page",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}