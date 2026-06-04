import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project2/assignment2/screen/general_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cambodia Traffic Law Quiz',
      debugShowCheckedModeBanner: false,
      theme:  ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
        ),
        textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 16.0)),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // TOP ICON
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF8B7BFF)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withValues(alpha: 0.25),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_police_rounded,
                  color: Colors.white,
                  size: 70,
                ),
              ),

              const SizedBox(height: 40),

              // TITLE
              const Text(
                'Cambodia Traffic Law Quiz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 18),

              // DESCRIPTION
              const Text(
                'Test your knowledge of Cambodia traffic laws and road signs through interactive quiz challenges.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              // FEATURE CARDS
              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.quiz_rounded,
                      title: '40+ Questions',
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.timer_outlined,
                      title: '45 Minutes',
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // START BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GeneralQuizScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded),
                      SizedBox(width: 8),
                      Text(
                        'Start Quiz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // EXIT BUTTON
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.exit_to_app_rounded),
                      SizedBox(width: 8),
                      Text(
                        'Exit App',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.deepPurple, size: 28),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
