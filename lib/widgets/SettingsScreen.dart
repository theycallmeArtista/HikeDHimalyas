import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HikedHimalayas/main.dart';  // Import your main.dart for ThemeNotifier

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the ThemeNotifier instance
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                value: themeNotifier.isDarkMode,
                onChanged: (bool value) {
                  // Toggle the theme on switch change
                  themeNotifier.toggleTheme();
                },
              ),
            ),
            const SizedBox(height: 20),
            // Add more settings if needed
          ],
        ),
      ),
    );
  }
}
