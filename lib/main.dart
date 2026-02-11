import 'package:flutter/material.dart';
import 'screens/ride_pref/ride_pref_screen.dart';
import 'theme/theme.dart';
import 'screens/screen_widget/app_widget/BlaButton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home:Scaffold(
        backgroundColor: const Color(0xFFEDEDED),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: RidePrefScreen(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Blabutton(
                      label: "Contact Volodia",
                      icon: Icons.chat_bubble_outline,
                      isPrimary: false,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    Blabutton(
                      label: "Request to book",
                      icon: Icons.event_seat,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

