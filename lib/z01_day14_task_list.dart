import 'package:flutter/material.dart';

// ============================================================================
// -== Flutter - Home work Lesson 14 ==-
// ============================================================================
// 1) Create a data list for display, for example:
//    List<String> tasks = ["Task 1", "Task 2", "Task 3"];
// 2) Create a list screen widget (for example, StatelessWidget TasksListScreen), in whose build method there will be a ListView list.
// 3) Use ListView.builder and set itemCount equal to tasks.length.
// 4) Return from itemBuilder a ListTile widget for each list element (use tasks[index] in title: Text(...)).
// 5) Add an icon to each list element: specify the leading (or trailing) property of ListTile with an icon, for example Icon(Icons.check_box_outline_blank).
// 6) Add separators between list elements: replace ListView.builder with ListView.separated and in the separatorBuilder property return a Divider() widget.
// 7) Implement handling of tapping on a list element: specify the onTap property of ListTile, inside which call, for example, print(tasks[index]) or show SnackBar with the name of the selected task.
// 8) Run the application and check: the list scrolls, each element has text, icon and separator, and when clicking on an element the corresponding message is displayed.

// ============================================================================
// Task 1: Create data list
// ============================================================================
final List<String> tasks = [
  "Complete Flutter homework",
  "Study ListView widgets",
  "Practice with ListTile",
  "Learn about separators",
  "Implement onTap handlers",
  "Test the application",
  "Review Material Design",
  "Build more Flutter apps",
  "Master navigation patterns",
  "Explore state management",
];

// ============================================================================
// Task 2: Create list screen widget (TasksListScreen)
// ============================================================================
class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  // Track checked state for each task
  late List<bool> checkedTasks;

  @override
  void initState() {
    super.initState();
    // Initialize all tasks as unchecked
    checkedTasks = List.generate(tasks.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 14 - Tasks List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'My Tasks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // ============================================================================
            // Task 3, 6: Use ListView.separated with itemCount
            // ============================================================================
            Expanded(
              child: ListView.separated(
                itemCount: tasks.length,
                // ============================================================================
                // Task 6: Add separators with separatorBuilder
                // ============================================================================
                separatorBuilder: (context, index) {
                  return const Divider(thickness: 1, indent: 16, endIndent: 16);
                },
                // ============================================================================
                // Task 4: Return ListTile for each element
                // ============================================================================
                itemBuilder: (context, index) {
                  return ListTile(
                    // ============================================================================
                    // Task 5: Add icon to each list element
                    // ============================================================================
                    leading: IconButton(
                      icon: Icon(
                        checkedTasks[index]
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          checkedTasks[index] = !checkedTasks[index];
                        });
                      },
                    ),
                    title: Text(
                      tasks[index],
                      style: TextStyle(
                        fontSize: 16,
                        decoration: checkedTasks[index]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: checkedTasks[index] ? Colors.grey : Colors.black,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    // ============================================================================
                    // Task 7: Implement onTap handler
                    // ============================================================================
                    onTap: () {
                      // Print to console
                      // print('Tapped: ${tasks[index]}');

                      // Show SnackBar with selected task name
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You selected: ${tasks[index]}'),
                          duration: const Duration(seconds: 5),
                          backgroundColor: Colors.blue,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
