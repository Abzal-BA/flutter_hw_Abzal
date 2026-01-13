import 'package:flutter/material.dart';

// ============================================================================
// -== Flutter - Home work Lesson 13 ==-
// ============================================================================
// 1) Create MainScreen widget (main application screen, can be StatelessWidget).
// 2) Add ElevatedButton with text on MainScreen that will open the details screen.
// 3) Create DetailsScreen widget and add a parameter to its constructor (for example, String detailText) to pass data to the details screen.
// 4) Configure the button on MainScreen: in its onPressed call Navigator.push with MaterialPageRoute creating DetailsScreen, and pass a string (for example, "Hello from MainScreen") through the detailText parameter.
// 5) Display the received detailText parameter on DetailsScreen in a Text widget.
// 6) Add a button on DetailsScreen that will open the settings screen when pressed.
// 7) Create SettingsScreen widget (for example, StatelessWidget) with simple content, for example Text("Settings").
// 8) Configure the button on DetailsScreen: in its onPressed call Navigator.push to navigate to SettingsScreen.
// 9) Add a "Back" button on DetailsScreen and SettingsScreen (for example, ElevatedButton or IconButton). In its press handler call Navigator.pop() to return to the previous screen.
// 10) Run the application and check navigation: from the main screen go to the details screen, then to the settings screen, then return back by pressing "Back" buttons (make sure transitions work correctly).

// ============================================================================
// Task 1-2: Create MainScreen widget with button
// ============================================================================
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 13 - Main Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Navigation Demo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // ============================================================================
              // Task 4: Button to navigate to DetailsScreen with data
              // ============================================================================
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailsScreen(
                        detailText: 'Hello from MainScreen!',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Open Details Screen',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Task 3: Create DetailsScreen with parameter
// ============================================================================
class DetailsScreen extends StatelessWidget {
  final String detailText;

  const DetailsScreen({super.key, required this.detailText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Details Screen',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              
              // ============================================================================
              // Task 5: Display received parameter
              // ============================================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  detailText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              
              // ============================================================================
              // Task 6-8: Button to navigate to SettingsScreen
              // ============================================================================
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Open Settings Screen',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              
              // ============================================================================
              // Task 9: Back button using Navigator.pop()
              // ============================================================================
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Back',
                  style: TextStyle(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Task 7: Create SettingsScreen widget
// ============================================================================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.settings,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 30),
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'This is the settings screen',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              
              // ============================================================================
              // Task 9: Back button using Navigator.pop()
              // ============================================================================
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Back',
                  style: TextStyle(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
