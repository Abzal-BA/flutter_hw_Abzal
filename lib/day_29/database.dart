import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// ============================================================================
// Tables Definition
// ============================================================================

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  
  // New field for migration demo
  TextColumn get category => text().withDefault(const Constant('general'))();
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get color => text().withDefault(const Constant('#2196F3'))();
}

// Junction table for many-to-many relationship
class TaskTags extends Table {
  IntColumn get taskId => integer().references(Tasks, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {taskId, tagId};
}

// ============================================================================
// Database Class
// ============================================================================

@DriftDatabase(tables: [Tasks, Tags, TaskTags])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Updated for migration

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Migration: Add category field to Tasks table
          await m.addColumn(tasks, tasks.category);
        }
      },
    );
  }

  // ============================================================================
  // Tasks CRUD Operations
  // ============================================================================

  // Create
  Future<int> addTask(TasksCompanion task) => into(tasks).insert(task);

  // Read - Single query (get)
  Future<Task> getTask(int id) => (select(tasks)..where((t) => t.id.equals(id))).getSingle();

  // Read - Stream (watch for real-time updates)
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Stream<List<Task>> watchTasksSortedByDate() {
    return (select(tasks)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Stream<List<Task>> watchTasksSortedByPriority() {
    return (select(tasks)..orderBy([(t) => OrderingTerm.desc(t.priority)])).watch();
  }

  Stream<List<Task>> watchCompletedTasks() {
    return (select(tasks)..where((t) => t.isCompleted.equals(true))).watch();
  }

  // Update
  Future<bool> updateTask(Task task) => update(tasks).replace(task);

  // Delete
  Future<int> deleteTask(int id) => (delete(tasks)..where((t) => t.id.equals(id))).go();

  // ============================================================================
  // Tags CRUD Operations
  // ============================================================================

  Future<int> addTag(TagsCompanion tag) => into(tags).insert(tag);

  Stream<List<Tag>> watchAllTags() => select(tags).watch();

  Future<bool> updateTag(Tag tag) => update(tags).replace(tag);

  Future<int> deleteTag(int id) => (delete(tags)..where((t) => t.id.equals(id))).go();

  // ============================================================================
  // Task-Tag Relations
  // ============================================================================

  Future<void> addTagToTask(int taskId, int tagId) {
    return into(taskTags).insert(
      TaskTagsCompanion.insert(taskId: taskId, tagId: tagId),
    );
  }

  Future<void> removeTagFromTask(int taskId, int tagId) {
    return (delete(taskTags)
          ..where((tt) => tt.taskId.equals(taskId) & tt.tagId.equals(tagId)))
        .go();
  }

  Stream<List<Tag>> watchTagsForTask(int taskId) {
    final query = select(tags).join([
      innerJoin(taskTags, taskTags.tagId.equalsExp(tags.id)),
    ])
      ..where(taskTags.taskId.equals(taskId));

    return query.watch().map((rows) => rows.map((row) => row.readTable(tags)).toList());
  }

  // ============================================================================
  // Export/Import JSON
  // ============================================================================

  Future<String> exportToJson() async {
    final allTasks = await select(tasks).get();
    final allTags = await select(tags).get();
    final allTaskTags = await select(taskTags).get();

    final data = {
      'tasks': allTasks.map((t) => {
            'id': t.id,
            'title': t.title,
            'description': t.description,
            'priority': t.priority,
            'createdAt': t.createdAt.toIso8601String(),
            'dueDate': t.dueDate?.toIso8601String(),
            'isCompleted': t.isCompleted,
            'category': t.category,
          }).toList(),
      'tags': allTags.map((t) => {
            'id': t.id,
            'name': t.name,
            'color': t.color,
          }).toList(),
      'taskTags': allTaskTags.map((tt) => {
            'taskId': tt.taskId,
            'tagId': tt.tagId,
          }).toList(),
    };

    return jsonEncode(data);
  }

  Future<void> importFromJson(String jsonData) async {
    final data = jsonDecode(jsonData) as Map<String, dynamic>;

    // Clear existing data
    await delete(taskTags).go();
    await delete(tasks).go();
    await delete(tags).go();

    // Import tasks
    if (data['tasks'] != null) {
      for (var taskData in data['tasks']) {
        await into(tasks).insert(
          TasksCompanion.insert(
            title: taskData['title'],
            description: Value(taskData['description']),
            priority: Value(taskData['priority']),
            createdAt: Value(DateTime.parse(taskData['createdAt'])),
            dueDate: Value(taskData['dueDate'] != null ? DateTime.parse(taskData['dueDate']) : null),
            isCompleted: Value(taskData['isCompleted']),
            category: Value(taskData['category'] ?? 'general'),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    }

    // Import tags
    if (data['tags'] != null) {
      for (var tagData in data['tags']) {
        await into(tags).insert(
          TagsCompanion.insert(
            name: tagData['name'],
            color: Value(tagData['color']),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    }

    // Import task-tag relations
    if (data['taskTags'] != null) {
      for (var ttData in data['taskTags']) {
        await into(taskTags).insert(
          TaskTagsCompanion.insert(
            taskId: ttData['taskId'],
            tagId: ttData['tagId'],
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
      
      // Ensure directory exists
      if (!await dbFolder.exists()) {
        await dbFolder.create(recursive: true);
      }
      
      print('Database path: ${file.path}');
      return NativeDatabase(file);
    } catch (e) {
      print('Error opening database: $e');
      rethrow;
    }
  });
}
