import 'package:flutter/material.dart';

// ============================================================================
// Flutter - Home work Lesson 10
// ============================================================================
// 1) Add a Text widget with a welcome message on the main screen (e.g., "Welcome to Flutter!").
// 2) Place an image below it using Image.network(...), specifying a URL to load the image from the internet.
// 3) Add an ElevatedButton below the image with text (e.g., "Press me"), which calls print() with a message to the console when pressed.
// 4) Wrap the text, image, and button in a Column for vertical layout of elements.
// 5) Add Padding (or padding property of a container) around elements to set margins.
// 6) Align the content on the screen to the center (use Center or mainAxisAlignment = MainAxisAlignment.center property of Column).
// 7) Run the application and make sure that text, image, and button are displayed correctly and respond to pressing.

class WelcomeApp extends StatelessWidget {
  const WelcomeApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const WelcomePage(title: 'Flutter lesson 10 - Home work');
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.title});
  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ============================================================================
              // Task 1: Welcome message
              // ============================================================================
              const Text(
                'Welcome to Flutter Home work app!\n My name is Abzal BAIKENOV \n Enjoy to check my code :)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Task 2: Image from the internet
              Image.network(
                'https://picsum.photos/300/200',
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              // ============================================================================
              // Task 3: Button with print action
              // ============================================================================
              ElevatedButton(
                onPressed: () {
                  // print('Button pressed!');
                },
                child: const Text('Press me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}