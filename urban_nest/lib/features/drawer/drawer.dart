import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_nest/features/auth/auth.dart';
import 'package:urban_nest/features/shared/theme_switch.dart';
import 'package:urban_nest/theme_notifier.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData =
    Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    final resHeight = MediaQuery.of(context).size.height;

    // Update the correct index for navigation, as 'pages' list contains only two pages
    final List<Widget> pages = [
      const CorporateAppPage(), // Index 0
      const SecuritySettingsPage(), // Index 1 (fixed the comment)
    ];

    Future<void> logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false); // Clear login status

      // Optionally, clear other saved data
      await prefs.remove('username');
      await prefs.remove('email');

      // Navigate back to the LoginScreen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Auth()),
        );
      }
    }

    return SizedBox(
      width: double.infinity,
      child: Drawer(
        backgroundColor: themeData.colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.only(left: 25, right: 25),
          children: [
            SizedBox(
              height: resHeight * 0.075,
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.onSurface,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: 60,
                child: Image.asset(
                  'assets/images/user.png',
                ),
              ),
            ),
            SizedBox(
              height: resHeight * 0.0175,
            ),
            Text(
              "Thomas",
              style: themeData.textTheme.headlineSmall,
            ),
            Text(
              "UX UI Designer",
              style: themeData.textTheme.titleMedium,
            ),
            SizedBox(
              height: resHeight * 0.04,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyBold.user_2),
              title: const Text('Community'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Auth()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person),
              title: const Text('Spin the Wheel'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Auth()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(IconlyBold.work),
              title: const Text('Leaderboard'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Auth()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: logout, // Use the same logout function
            ),
            const SizedBox(height: 20),
            const ThemeSwitch(),
          ],
        ),
      ),
    );
  }
}

class DrawerItems extends StatelessWidget {
  final String text;
  final String image;
  final int index;
  final List<Widget> pages; // Add list of pages for navigation

  const DrawerItems({
    super.key,
    required this.text,
    required this.image,
    required this.index,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        image,
        color: themeData.iconTheme.color,
        width: 30,
        height: 30,
      ),
      onTap: () {
        // Navigate to the page based on index
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pages[index]),
        );
      },
      title: Text(text, style: themeData.textTheme.bodyMedium),
    );
  }
}

// Dummy pages for navigation example
class CorporateAppPage extends StatelessWidget {
  const CorporateAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Corporate App")),
      body: const Center(child: Text("Corporate App Page")),
    );
  }
}

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Security Settings")),
      body: const Center(child: Text("Security Settings Page")),
    );
  }
}
