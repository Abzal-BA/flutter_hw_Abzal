import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'database.dart';

// ============================================================================
// Flutter - Home work Lesson 29
// ============================================================================
// 1) Learn: Drift database with tables and relations
//    - Create 2 tables (Tasks, Tags) with foreign key
// 2) Learn: CRUD operations with sorting
//    - Add/Edit/Delete records + sort by date/priority
// 3) Learn: Stream updates with watch() vs get()
//    - Real-time UI updates comparison
// 4) Learn: Database migration
//    - Add new field with default value
// 5) Practice:
//    - Export/Import data to JSON file
//    - Complete task management app

class Day29DriftDatabaseApp extends StatefulWidget {
  const Day29DriftDatabaseApp({super.key});

  @override
  State<Day29DriftDatabaseApp> createState() => _Day29DriftDatabaseAppState();
}

class _Day29DriftDatabaseAppState extends State<Day29DriftDatabaseApp>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final AppDatabase database;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    database = AppDatabase();
  }

  @override
  void dispose() {
    _tabController.dispose();
    database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Day 29 · Drift Database'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: '🗄️ Tables'),
            Tab(text: '➕ CRUD'),
            Tab(text: '👀 Watch'),
            Tab(text: '🔄 Migration'),
            Tab(text: '📁 Export'),
            Tab(text: '🧪 Practice'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TablesTab(database: database),
          _CrudTab(database: database),
          _WatchTab(database: database),
          _MigrationTab(database: database),
          _ExportTab(database: database),
          _PracticeTab(database: database),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 1: Tables & Relations
// ============================================================================

class _TablesTab extends StatelessWidget {
  final AppDatabase database;

  const _TablesTab({required this.database});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Database Tables & Relations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Tables Created:\n\n'
            '1️⃣ Tasks Table:\n'
            '   • id (Primary Key)\n'
            '   • title\n'
            '   • description\n'
            '   • priority (0-5)\n'
            '   • createdAt\n'
            '   • dueDate\n'
            '   • isCompleted\n'
            '   • category (added via migration)\n\n'
            '2️⃣ Tags Table:\n'
            '   • id (Primary Key)\n'
            '   • name\n'
            '   • color\n\n'
            '3️⃣ TaskTags Table (Junction):\n'
            '   • taskId (Foreign Key → Tasks)\n'
            '   • tagId (Foreign Key → Tags)\n'
            '   • Composite Primary Key (taskId, tagId)\n\n'
            'Relations:\n'
            '• Many-to-Many: Tasks ↔ Tags\n'
            '• Cascade Delete: Delete task → delete relations\n\n'
            'Key Features:\n'
            '✅ Auto-increment IDs\n'
            '✅ Foreign key constraints\n'
            '✅ Default values\n'
            '✅ Nullable fields\n'
            '✅ Type safety with Drift',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 2: CRUD Operations
// ============================================================================

class _CrudTab extends StatefulWidget {
  final AppDatabase database;

  const _CrudTab({required this.database});

  @override
  State<_CrudTab> createState() => _CrudTabState();
}

class _CrudTabState extends State<_CrudTab> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  int _priority = 1;
  String _sortBy = 'date';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Title is required!')),
      );
      return;
    }

    try {
      await widget.database.addTask(
        TasksCompanion.insert(
          title: _titleController.text,
          description: drift.Value(_descController.text),
          priority: drift.Value(_priority),
        ),
      );

      _titleController.clear();
      _descController.clear();
      setState(() => _priority = 1);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Task added!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteTask(int id) async {
    await widget.database.deleteTask(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🗑️ Task deleted!')),
      );
    }
  }

  Future<void> _toggleComplete(Task task) async {
    await widget.database.updateTask(
      task.copyWith(isCompleted: !task.isCompleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add Task Form
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Priority:'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: _priority.toDouble(),
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _priority.toString(),
                      onChanged: (v) => setState(() => _priority = v.toInt()),
                    ),
                  ),
                  Text(_priority.toString()),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Task'),
                ),
              ),
            ],
          ),
        ),
        // Sort Options
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text('Sort by:'),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Date'),
                selected: _sortBy == 'date',
                onSelected: (v) => setState(() => _sortBy = 'date'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Priority'),
                selected: _sortBy == 'priority',
                onSelected: (v) => setState(() => _sortBy = 'priority'),
              ),
            ],
          ),
        ),
        // Tasks List
        Expanded(
          child: StreamBuilder<List<Task>>(
            stream: _sortBy == 'date'
                ? widget.database.watchTasksSortedByDate()
                : widget.database.watchTasksSortedByPriority(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tasks = snapshot.data!;

              if (tasks.isEmpty) {
                return const Center(
                  child: Text('No tasks yet. Add one above!'),
                );
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleComplete(task),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        'Priority: ${task.priority} • ${task.category}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(task.priority),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${task.priority}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(task.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(int priority) {
    if (priority >= 4) return Colors.red;
    if (priority >= 2) return Colors.orange;
    return Colors.blue;
  }
}

// ============================================================================
// Tab 3: Watch vs Get Comparison
// ============================================================================

class _WatchTab extends StatefulWidget {
  final AppDatabase database;

  const _WatchTab({required this.database});

  @override
  State<_WatchTab> createState() => _WatchTabState();
}

class _WatchTabState extends State<_WatchTab> {
  List<Task> _getTasksCache = [];
  int _getCallCount = 0;
  int _watchUpdateCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTasksWithGet();
  }

  Future<void> _loadTasksWithGet() async {
    final tasks = await widget.database.select(widget.database.tasks).get();
    setState(() {
      _getTasksCache = tasks;
      _getCallCount++;
    });
  }

  Future<void> _addDemoTask() async {
    await widget.database.addTask(
      TasksCompanion.insert(
        title: 'Demo Task ${DateTime.now().second}',
        priority: const drift.Value(3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'watch() vs get() Comparison',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _addDemoTask,
            icon: const Icon(Icons.add),
            label: const Text('Add Demo Task'),
          ),
          const SizedBox(height: 24),
          // get() section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'get() - Manual Refresh',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _loadTasksWithGet,
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
                Text('Get calls: $_getCallCount'),
                const SizedBox(height: 8),
                const Text('Tasks:'),
                ..._getTasksCache.map((task) => Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text('• ${task.title}'),
                    )),
                if (_getTasksCache.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No tasks (click Refresh)'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // watch() section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'watch() - Auto Updates',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                StreamBuilder<List<Task>>(
                  stream: widget.database.watchAllTasks(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() => _watchUpdateCount++);
                        }
                      });
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stream updates: $_watchUpdateCount'),
                        const SizedBox(height: 8),
                        const Text('Tasks:'),
                        if (snapshot.hasData)
                          ...snapshot.data!.map((task) => Padding(
                                padding: const EdgeInsets.only(left: 16, top: 4),
                                child: Text('• ${task.title}'),
                              ))
                        else
                          const CircularProgressIndicator(),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Key Differences:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('get():'),
                Text('  • One-time query'),
                Text('  • Manual refresh needed'),
                Text('  • Lower overhead'),
                SizedBox(height: 8),
                Text('watch():'),
                Text('  • Real-time stream'),
                Text('  • Auto UI updates'),
                Text('  • Perfect for reactive UIs'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 4: Migration
// ============================================================================

class _MigrationTab extends StatelessWidget {
  final AppDatabase database;

  const _MigrationTab({required this.database});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Database Migration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Schema Version: 2',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Migration Applied:\n\n'
            'Version 1 → 2:\n'
            '• Added "category" field to Tasks table\n'
            '• Default value: "general"\n'
            '• Type: Text/String\n\n'
            'Migration Code:\n'
            'onUpgrade: (m, from, to) async {\n'
            '  if (from < 2) {\n'
            '    await m.addColumn(tasks, tasks.category);\n'
            '  }\n'
            '}\n\n'
            'How It Works:\n'
            '1️⃣ Drift detects schema version change\n'
            '2️⃣ Runs onUpgrade migration\n'
            '3️⃣ Adds new column with default value\n'
            '4️⃣ Existing data remains intact\n\n'
            'All existing tasks now have:\n'
            '✅ category = "general" (default)\n'
            '✅ No data loss\n'
            '✅ Type-safe access',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Card(
            color: Color(0xFFE8F5E9),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ Migration Complete',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The category field is now available on all tasks. '
                    'Check the CRUD tab to see it in action!',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 5: Export/Import
// ============================================================================

class _ExportTab extends StatefulWidget {
  final AppDatabase database;

  const _ExportTab({required this.database});

  @override
  State<_ExportTab> createState() => _ExportTabState();
}

class _ExportTabState extends State<_ExportTab> {
  String _status = 'Ready to export/import data';
  bool _loading = false;

  Future<void> _exportData() async {
    setState(() {
      _loading = true;
      _status = 'Exporting data...';
    });

    try {
      final jsonData = await widget.database.exportToJson();
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/tasks_export.json');
      await file.writeAsString(jsonData);

      setState(() {
        _status = '✅ Exported to: ${file.path}\n\nData preview:\n${jsonData.substring(0, 200)}...';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Export failed: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _importData() async {
    setState(() {
      _loading = true;
      _status = 'Importing data...';
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/tasks_export.json');

      if (!await file.exists()) {
        setState(() {
          _status = '❌ No export file found. Export first!';
        });
        return;
      }

      final jsonData = await file.readAsString();
      await widget.database.importFromJson(jsonData);

      setState(() {
        _status = '✅ Data imported successfully!';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Import failed: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addSampleData() async {
    // Add sample tasks
    await widget.database.addTask(
      TasksCompanion.insert(
        title: 'Sample Task 1',
        description: const drift.Value('This is a sample task'),
        priority: const drift.Value(2),
      ),
    );
    await widget.database.addTask(
      TasksCompanion.insert(
        title: 'Sample Task 2',
        description: const drift.Value('Another sample'),
        priority: const drift.Value(4),
      ),
    );

    // Add sample tags
    await widget.database.addTag(
      TagsCompanion.insert(
        name: 'Important',
        color: const drift.Value('#F44336'),
      ),
    );
    await widget.database.addTag(
      TagsCompanion.insert(
        name: 'Work',
        color: const drift.Value('#2196F3'),
      ),
    );

    setState(() {
      _status = '✅ Sample data added! Now try exporting.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Export/Import JSON',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loading ? null : _addSampleData,
            icon: const Icon(Icons.add_circle),
            label: const Text('Add Sample Data'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _loading ? null : _exportData,
            icon: const Icon(Icons.upload_file),
            label: const Text('Export to JSON'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _loading ? null : _importData,
            icon: const Icon(Icons.download),
            label: const Text('Import from JSON'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          const SizedBox(height: 16),
          if (_loading) const LinearProgressIndicator(),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: SingleChildScrollView(
                child: Text(_status),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 6: Complete Practice
// ============================================================================

class _PracticeTab extends StatefulWidget {
  final AppDatabase database;

  const _PracticeTab({required this.database});

  @override
  State<_PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<_PracticeTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete Task Manager',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '✅ Tables: Tasks, Tags, TaskTags (relations)\n'
                '✅ CRUD: Create, Read, Update, Delete\n'
                '✅ Sorting: By Date and Priority\n'
                '✅ Real-time: watch() streams\n'
                '✅ Migration: Category field added\n'
                '✅ Export/Import: JSON format',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Task>>(
            stream: widget.database.watchAllTasks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tasks = snapshot.data!;
              final completed = tasks.where((t) => t.isCompleted).length;
              final total = tasks.length;

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue.shade50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCard(
                          title: 'Total',
                          value: total.toString(),
                          icon: Icons.list,
                          color: Colors.blue,
                        ),
                        _StatCard(
                          title: 'Completed',
                          value: completed.toString(),
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                        _StatCard(
                          title: 'Pending',
                          value: (total - completed).toString(),
                          icon: Icons.pending,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: tasks.isEmpty
                        ? const Center(
                            child: Text('No tasks. Add some in CRUD tab!'),
                          )
                        : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    task.isCompleted
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: task.isCompleted
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${task.category} • Priority: ${task.priority}',
                                  ),
                                  trailing: Text(
                                    task.createdAt
                                        .toString()
                                        .substring(0, 10),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
