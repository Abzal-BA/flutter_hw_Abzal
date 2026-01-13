import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// -== Flutter - Home work Lesson 16 ==-
// ============================================================================
// 1) Add shared_preferences package to pubspec.yaml and import SharedPreferences class in code.
// 2) Create CounterModel class with int counter field and loadCounter() and saveCounter() methods. In loadCounter() get the saved value from SharedPreferences (by key, for example "counter", return 0 if value is missing). In saveCounter() save the current counter value to SharedPreferences.
// 3) Add increment() method to CounterModel that increases counter by 1 and calls saveCounter() to save the new value.
// 4) Create StatefulWidget CounterPage and in its state declare variable counterModel = CounterModel().
// 5) In initState call counterModel.loadCounter() (asynchronously) and after loading the value execute setState() to update state.
// 6) In build method return Scaffold. In body place Column, inside which will be Text and ElevatedButton.
// 7) Display in Text the current value of counterModel.counter. In button's onPressed call counterModel.increment() and then setState() to update UI.
// 8) Run the application. Press the button several times - the counter value should increase. Restart the application and make sure the last counter result is saved and loaded (i.e. the value is not reset on new launch).

// ============================================================================
// Task 2, 3: Create CounterModel class with persistence
// ============================================================================
class CounterModel {
  int counter = 0;
  static const String _counterKey = 'counter';

  // Task 2: Load counter from SharedPreferences
  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt(_counterKey) ?? 0;
  }

  // Task 2: Save counter to SharedPreferences
  Future<void> saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, counter);
  }

  // Task 3: Increment counter and save
  Future<void> increment() async {
    counter++;
    await saveCounter();
  }

  // Additional method: Reset counter
  Future<void> reset() async {
    counter = 0;
    await saveCounter();
  }
}

// ============================================================================
// Task 4: Create StatefulWidget CounterPage
// ============================================================================
class PersistentCounterPage extends StatefulWidget {
  const PersistentCounterPage({super.key});

  @override
  State<PersistentCounterPage> createState() => _PersistentCounterPageState();
}

class _PersistentCounterPageState extends State<PersistentCounterPage> {
  // Task 4: Declare counterModel variable
  final CounterModel counterModel = CounterModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Task 5: Load counter asynchronously and update state
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    await counterModel.loadCounter();
    setState(() {
      isLoading = false;
    });
  }

  // Task 7: Increment counter and update UI
  Future<void> _incrementCounter() async {
    await counterModel.increment();
    setState(() {});
  }

  // Additional method: Reset counter
  Future<void> _resetCounter() async {
    await counterModel.reset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Task 6: Return Scaffold with Column containing Text and ElevatedButton
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 16 - Persistent Counter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Persistent Counter',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'This counter value is saved and persists across app restarts',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    // Task 7: Display counter value
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        '${counterModel.counter}',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Task 7: Button to increment counter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _incrementCounter,
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'Increment',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: _resetCounter,
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            'Reset',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Info card
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Try closing and reopening the app. The counter value will be preserved!',
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
