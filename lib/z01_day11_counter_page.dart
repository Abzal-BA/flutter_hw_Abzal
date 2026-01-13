import 'package:flutter/material.dart';

// ============================================================================
// Flutter - Home work Lesson 11
// ============================================================================
// 1) Create new StatefulWidget (example, CounterPage) for screen with counter.
// 2) Declare a variable int counter = 0 in the state class (State<CounterPage>) to store the current counter value.
// 3) In the build method return Scaffold with body: Center(…) or Column(…) depending on desired element placement.
// 4) Place two widgets inside Center/Column: Text and ElevatedButton.
// 5) Display the current counter value in the Text widget ($counter).
// 6) In the ElevatedButton's onPressed handler, call setState() and increment counter by 1.
// 7) Run the application and verify: the text counter should increment with each button press.

// ============================================================================
// Task 1: Create new StatefulWidget (CounterPage)
// ============================================================================
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

// ============================================================================
// Task 2: Declare counter variable in State class
// ============================================================================
class _CounterPageState extends State<CounterPage> {
  int counter = 0;

  // ============================================================================
  // Task 3: Build method returns Scaffold with Center/Column
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 11 - Counter Page'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ============================================================================
            // Task 4-5: Display counter value in Text widget
            // ============================================================================
            Text(
              '$counter',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            // ============================================================================
            // Task 6: ElevatedButton with setState() to increment counter
            // ============================================================================
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },
              child: const Text('Increment Counter'),
            ),
          ],
        ),
      ),
    );
  }
}