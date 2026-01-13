import 'package:flutter/material.dart';

// ============================================================================
// Flutter - Home work Lesson 9
// ============================================================================
// 1) Install Flutter SDK and necessary software (Android Studio or VS Code with Flutter/Dart plugins).
// 2) Set up Android emulator or connect a real device to run applications.
// 3) Create a new Flutter project (via command line flutter create or IDE tools).
// 4) Open lib/main.dart file, remove the template counter code and display "Hello, Flutter!" text on screen (use MaterialApp -> Scaffold -> Center -> Text).
// 5) Run the application on emulator/device - "Hello, Flutter!" should be displayed on screen.
// 6) Change the text in the Text widget (for example, to "Hello, Flutter!!!") and apply Hot Reload to instantly see the update.
// 7) Perform Hot Restart (full restart) and make sure the application starts from the initial state.

class HwApp extends StatelessWidget {
  const HwApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const HwPage(title: 'Flutter lesson 9 - Home work');
  }
}

class HwPage extends StatefulWidget {
  const HwPage({super.key, required this.title});
  final String title;

  @override
  State<HwPage> createState() => _HwPageState();
}

class _HwPageState extends State<HwPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Hello, Flutter!'),
          ],
        ),   
      ), 
    );
  }
}