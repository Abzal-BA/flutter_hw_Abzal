import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ================================================================================
// ==-= Flutter - Home work Lesson 17 =-=
// ================================================================================
// 1) Add provider package to pubspec.yaml and import it into the project.
// 2) Create TasksProvider class extending ChangeNotifier. Define in it List<String> tasks = [] and methods: addTask(String task) and removeTask(int index).
// 3) Wrap the MaterialApp widget in ChangeNotifierProvider (in the build method of the top widget), passing create: (_) => TasksProvider().
// 4) Use Provider on the task list screen: get the task list through context.watch<TasksProvider>().tasks.
// 5) Display tasks using ListView.builder (similar to Day 14), using the list from the provider instead of hardcoded data.
// 6) Add FloatingActionButton to add a new task. In its onPressed call context.read<TasksProvider>().addTask("New Task").
// 7) Implement task deletion: set the ListTile's onLongPress property, inside which call context.read<TasksProvider>().removeTask(index) to remove the element.
// 8) Run the application: check that when pressing FAB a new task is added to the list, when long pressing on an element it is deleted. Make sure that the UI updates automatically when the list changes (without separate setState in the list widget).

// ================================================================================
// Task 1: Create TasksProvider class with state management
// ================================================================================

// Task 1: TasksProvider extends ChangeNotifier for state management
class TasksProvider extends ChangeNotifier {
  final List<String> _tasks = [];

  List<String> get tasks => _tasks;

  // Task 1: Add task method - adds task to list and notifies listeners
  void addTask(String task) {
    _tasks.add(task);
    notifyListeners();
  }

  // Task 1: Remove task method - removes task from list and notifies listeners
  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}

// ================================================================================
// Task 2, 3: Wrap MaterialApp with ChangeNotifierProvider
// ================================================================================

// Task 3: Main app wrapped with ChangeNotifierProvider
class ProviderTaskListApp extends StatelessWidget {
  const ProviderTaskListApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Task 3: Wrap with ChangeNotifierProvider, create TasksProvider instance
    return ChangeNotifierProvider(
      create: (_) => TasksProvider(),
      child: const TaskListScreen(),
    );
  }
}

// ================================================================================
// Task 4, 5, 6, 7: Task List Screen with Provider
// ================================================================================

// Task 4, 5: Task List Screen using Provider for state management
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Task 4: Watch the TasksProvider for changes using context.watch
    final tasksProvider = context.watch<TasksProvider>();
    final tasks = tasksProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Provider Task List'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet!\nTap + to add a task',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          // Task 5: Display tasks using ListView.builder with data from provider
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 38, 64, 84),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(tasks[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        // Delete task by tapping the delete icon
                        context.read<TasksProvider>().removeTask(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task deleted'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    // Task 7: Long press to delete task using context.read
                    onLongPress: () {
                      context.read<TasksProvider>().removeTask(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task deleted'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      // Task 6: FloatingActionButton to add new task using context.read
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Task 6: Add new task using context.read<TasksProvider>().addTask()
          context.read<TasksProvider>().addTask("New Task");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New task added'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ================================================================================
// Task 8: Result - UI updates automatically without setState thanks to Provider
// ================================================================================
