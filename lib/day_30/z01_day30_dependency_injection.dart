import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'models.dart';
import 'service_locator.dart';
import 'use_cases.dart';

// ============================================================================
// Flutter - Day 30 Lesson
// ============================================================================
// 1) Learn: Register dependencies in get_it (ApiClient, Repository, UseCase)
// 2) Learn: Mock vs Real implementation (debug/release)
// 3) Learn: Async initialization before runApp
// 4) Practice: Get dependencies via constructor and use them in UI
// 5) Test: Unit tests with dependency substitution

class Day30DependencyInjectionApp extends StatefulWidget {
  const Day30DependencyInjectionApp({super.key});

  @override
  State<Day30DependencyInjectionApp> createState() =>
      _Day30DependencyInjectionAppState();
}

class _Day30DependencyInjectionAppState
    extends State<Day30DependencyInjectionApp>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        title: const Text('Day 30 · Dependency Injection'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 76, 40, 130),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: '📦 Setup'),
            Tab(text: '👥 Users'),
            Tab(text: '🔄 Mock/Real'),
            Tab(text: '⭐ Favorite'),
            Tab(text: '📝 Practice'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _SetupTab(),
          _UsersTab(),
          _MockRealTab(),
          _FavoriteTab(),
          _PracticeTab(),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 1: Setup Explanation
// ============================================================================

class _SetupTab extends StatelessWidget {
  const _SetupTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dependency Injection Setup',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: '1️⃣ Service Locator (get_it)',
            content: 'GetIt is a simple service locator for Dart and Flutter.\n\n'
                'Benefits:\n'
                '• Single source of truth for dependencies\n'
                '• Easy to test (swap real → mock)\n'
                '• Decoupled architecture\n'
                '• No InheritedWidget complexity',
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: '2️⃣ Registered Dependencies',
            content: 'ApiClient (Lazy Singleton)\n'
                '  └─ Mock or Real based on kDebugMode\n\n'
                'SharedPreferences (Singleton)\n'
                '  └─ Async init before runApp\n\n'
                'UserRepository (Lazy Singleton)\n'
                '  └─ Depends on: ApiClient + SharedPreferences\n\n'
                'Use Cases (Factory)\n'
                '  └─ GetUsersUseCase\n'
                '  └─ GetUserPostsUseCase\n'
                '  └─ CreateUserUseCase\n'
                '  └─ FavoriteUserUseCase',
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          // ============================================================
          // 📱 ASYNC INITIALIZATION EXPLANATION
          // ============================================================
          // Critical pattern: Initialize async services BEFORE runApp()
          // Prevents crashes from accessing uninitialized dependencies
          _InfoCard(
            title: '3️⃣ Async Initialization',
            content: '🎯 WHY WE NEED IT:\n'
                'Some services need async setup (SharedPreferences, Firebase, DB)\n'
                'Without waiting → widgets crash accessing uninitialized services!\n\n'
                '🔧 HOW IT WORKS:\n'
                'main() async {\n'
                '  // 1. Prepare Flutter framework\n'
                '  WidgetsFlutterBinding.ensureInitialized();\n'
                '  \n'
                '  // 2. Wait for dependencies (BLOCKS here)\n'
                '  await setupServiceLocator();\n'
                '  \n'
                '  // 3. Start app (dependencies ready!)\n'
                '  runApp(MyApp());\n'
                '}\n\n'
                '⏱️ WHAT HAPPENS:\n'
                '• App waits at await until SharedPreferences loads\n'
                '• All services registered in get_it\n'
                '• Only then does first widget build\n'
                '• Safe to call getIt<T>() anywhere!\n\n'
                '✅ BENEFITS:\n'
                '• No race conditions\n'
                '• Guaranteed service availability\n'
                '• Predictable startup sequence\n'
                '• Clean error handling',
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kDebugMode ? Colors.yellow.shade100 : Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: kDebugMode ? Colors.yellow.shade700 : Colors.green.shade700,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔧 Current Mode: ${kDebugMode ? "DEBUG" : "RELEASE"}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  kDebugMode
                      ? '✅ Using MockApiClient (fake data, no internet needed)'
                      : '✅ Using RealApiClient (real API calls)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 2: Users List (Using Dependency Injection)
// ============================================================================

class _UsersTab extends StatefulWidget {
  const _UsersTab();

  @override
  State<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<_UsersTab> {
  // ✅ Get dependencies via get_it
  GetUsersUseCase? _getUsersUseCase;
  GetUserPostsUseCase? _getUserPostsUseCase;

  List<User> _users = [];
  bool _loading = true;
  String? _error;
  User? _selectedUser;
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _initAndLoadData();
  }

  Future<void> _initAndLoadData() async {
    try {
      // ============================================================
      // 🔧 DEPENDENCY INJECTION using get_it
      // ============================================================
      // Instead of creating instances manually (new GetUsersUseCase()),
      // we retrieve them from the service locator (getIt).
      //
      // Benefits:
      // ✅ Single source of truth for dependencies
      // ✅ Easy to swap implementations (Mock ↔️ Real)
      // ✅ Dependencies are shared across the app (singleton pattern)
      // ✅ Testing becomes easier (can replace with test doubles)
      //
      // getIt<T>() - Retrieves registered instance of type T
      // ============================================================
      
      // Get the use case for fetching all users
      // This use case internally uses Repository → ApiClient
      _getUsersUseCase = getIt<GetUsersUseCase>();
      
      // Get the use case for fetching posts of a specific user
      // Registered as Factory = new instance every time
      _getUserPostsUseCase = getIt<GetUserPostsUseCase>();
      
      await _loadUsers();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to initialize: $e';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadUsers() async {
    if (_getUsersUseCase == null) return;
    
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final users = await _getUsersUseCase!.execute();
      setState(() {
        _users = users;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadPosts(User user) async {
    if (_getUserPostsUseCase == null) return;
    
    setState(() {
      _selectedUser = user;
      _posts = [];
    });

    try {
      final posts = await _getUserPostsUseCase!.execute(user.id);
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUsers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        // Users list
        Expanded(
          flex: 2,
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              final isSelected = _selectedUser?.id == user.id;
              
              return ListTile(
                selected: isSelected,
                leading: CircleAvatar(
                  child: Text(user.name[0]),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _loadPosts(user),
              );
            },
          ),
        ),
        // Posts list
        Expanded(
          flex: 3,
          child: _selectedUser == null
              ? const Center(
                  child: Text('Select a user to see posts'),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.purple.shade100,
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text(_selectedUser!.name[0]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedUser!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(_selectedUser!.email),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _posts.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: _posts.length,
                              itemBuilder: (context, index) {
                                final post = _posts[index];
                                return Card(
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(post.body),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ============================================================================
// Tab 3: Mock vs Real Comparison
// ============================================================================
// This tab demonstrates how to switch between Mock and Real implementations
// using kDebugMode flag and Dependency Injection.
//
// 🎯 PATTERN: Strategy Pattern via Service Locator
// - Both MockApiClient and RealApiClient implement the same ApiClient interface
// - get_it registers the appropriate implementation based on build mode
// - The rest of the app doesn't know which implementation is being used!
//
// 🔧 HOW IT WORKS:
// 1. In service_locator.dart, we check kDebugMode flag
// 2. If debugging: register MockApiClient (fake data, fast, offline)
// 3. If release: register RealApiClient (real HTTP calls to API)
// 4. All other code uses ApiClient interface - no changes needed!
//
// ✅ BENEFITS:
// - Develop without internet connection
// - Fast, predictable test data during development
// - Automatically use real API in production
// - Easy to test (just swap the implementation in get_it)
// - No if/else scattered throughout the codebase
//
// 🚀 TO SWITCH MODES:
// - Debug mode: flutter run (default)
// - Release mode: flutter run --release

class _MockRealTab extends StatelessWidget {
  const _MockRealTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mock vs Real Implementation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // ===================================================
          // 🐛 MOCK IMPLEMENTATION (Debug Mode)
          // ===================================================
          // MockApiClient returns hardcoded data instantly
          // Perfect for development, UI testing, offline work
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.yellow.shade700),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🐛 Debug Mode (MockApiClient)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('✅ No internet required'),
                Text('✅ Instant responses (500ms delay)'),
                Text('✅ Predictable test data'),
                Text('✅ Perfect for development'),
                Text('✅ Works offline'),
                SizedBox(height: 8),
                Text('Data Source: Hardcoded mock data'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ===================================================
          // 🚀 REAL IMPLEMENTATION (Release Mode)
          // ===================================================
          // RealApiClient makes actual HTTP requests
          // Used in production builds for live data
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade700),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚀 Release Mode (RealApiClient)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('✅ Real API calls'),
                Text('✅ Live data from jsonplaceholder'),
                Text('✅ Network dependent'),
                Text('✅ Production ready'),
                SizedBox(height: 8),
                Text('Data Source: https://jsonplaceholder.typicode.com'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'How it works:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // ===================================================
          // 📝 CODE EXAMPLE: Switching Logic in service_locator.dart
          // ===================================================
          // kDebugMode is a compile-time constant from Flutter
          // It's true when running in debug mode (flutter run)
          // It's false when running in release mode (flutter run --release)
          //
          // This allows the compiler to optimize out unused code:
          // - In debug builds, RealApiClient code is removed
          // - In release builds, MockApiClient code is removed
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'if (kDebugMode) {\n'
              '  getIt.registerLazySingleton<ApiClient>(\n'
              '    () => MockApiClient(),\n'
              '  );\n'
              '} else {\n'
              '  getIt.registerLazySingleton<ApiClient>(\n'
              '    () => RealApiClient(),\n'
              '  );\n'
              '}',
              style: TextStyle(fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 16),
          // ===================================================
          // 📊 CURRENT MODE INDICATOR
          // ===================================================
          // Shows which implementation is currently running
          // The UI automatically reflects the build mode
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // 🎨 Dynamic styling based on kDebugMode
              // Yellow for debug (mock), green for release (real)
              color: kDebugMode ? Colors.yellow.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  // 🎯 Different icon based on mode
                  kDebugMode ? Icons.bug_report : Icons.rocket_launch,
                  size: 48,
                  color: kDebugMode ? Colors.orange : Colors.green,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currently Running:',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        kDebugMode ? 'MockApiClient' : 'RealApiClient',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 4: Favorite User (SharedPreferences via DI)
// ============================================================================

class _FavoriteTab extends StatefulWidget {
  const _FavoriteTab();

  @override
  State<_FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<_FavoriteTab> {
  GetUsersUseCase? _getUsersUseCase;
  FavoriteUserUseCase? _favoriteUseCase;

  List<User> _users = [];
  int? _favoriteUserId;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initAndLoadData();
  }

  Future<void> _initAndLoadData() async {
    try {
      // ============================================================
      // 🔧 DEPENDENCY INJECTION for Favorite Tab
      // ============================================================
      // Retrieving use cases from the global service locator (getIt)
      // These were registered in service_locator.dart during app startup
      // ============================================================
      
      // Get use case for fetching users list
      // Same instance as used in Users tab (lazy singleton)
      _getUsersUseCase = getIt<GetUsersUseCase>();
      
      // Get use case for managing favorite user
      // Handles save/load favorite user ID to/from SharedPreferences
      _favoriteUseCase = getIt<FavoriteUserUseCase>();
      
      await _loadData();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to initialize: $e';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadData() async {
    if (_getUsersUseCase == null || _favoriteUseCase == null) return;
    
    try {
      final users = await _getUsersUseCase!.execute();
      final favoriteId = await _favoriteUseCase!.getFavorite();
      
      if (mounted) {
        setState(() {
          _users = users;
          _favoriteUserId = favoriteId;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load data: $e';
          _loading = false;
        });
      }
    }
  }

  Future<void> _setFavorite(int userId) async {
    if (_favoriteUseCase == null) return;
    
    await _favoriteUseCase!.setFavorite(userId);
    setState(() {
      _favoriteUserId = userId;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⭐ Favorite saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initAndLoadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (_favoriteUserId != null && _users.isNotEmpty)
          Builder(
            builder: (context) {
              // Safe lookup with fallback
              final favoriteUser = _users
                  .cast<User?>()
                  .firstWhere(
                    (u) => u?.id == _favoriteUserId,
                    orElse: () => null,
                  );

              if (favoriteUser == null) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade200,
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.grey),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your favorite user was not found. Please select a new one.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.amber.shade100,
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Favorite User:',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            favoriteUser.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              final isFavorite = user.id == _favoriteUserId;
              
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.name[0]),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.amber : null,
                  ),
                  onPressed: () => _setFavorite(user.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Tab 5: Practice - Create User
// ============================================================================

class _PracticeTab extends StatefulWidget {
  const _PracticeTab();

  @override
  State<_PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<_PracticeTab> {
  CreateUserUseCase? _createUserUseCase;
  GetUsersUseCase? _getUsersUseCase;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  List<User> _users = [];
  bool _creating = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  Future<void> _initializeDependencies() async {
    try {
      // ============================================================
      // 🔧 DEPENDENCY INJECTION for Practice Tab
      // ============================================================
      // Pattern: Constructor Injection via Service Locator
      // Instead of: new CreateUserUseCase(repository)
      // We use: getIt<CreateUserUseCase>() - already wired up!
      // ============================================================
      
      // Get use case for creating new users
      // Contains validation logic (email format, name length)
      // Registered as Factory = new instance each time we call getIt
      _createUserUseCase = getIt<CreateUserUseCase>();
      
      // Get use case for fetching all users
      // Used to refresh the list after creating a new user
      // Registered as Factory instance
      _getUsersUseCase = getIt<GetUsersUseCase>();
      
      await _loadUsers();
      
      setState(() => _initialized = true);
    } catch (e) {
      print('Error initializing dependencies: $e');
      if (mounted) {
        setState(() => _initialized = true); // Show error state
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    if (_getUsersUseCase == null) return;
    final users = await _getUsersUseCase!.execute();
    if (mounted) {
      setState(() => _users = users);
    }
  }

  Future<void> _createUser() async {
    if (_createUserUseCase == null) return;
    
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please fill all fields')),
      );
      return;
    }

    setState(() => _creating = true);

    try {
      final newUser = await _createUserUseCase!.execute(
        _nameController.text,
        _emailController.text,
      );

      _nameController.clear();
      _emailController.clear();
      
      await _loadUsers();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ User ${newUser.name} created!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    } finally {
      setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing dependencies...'),
          ],
        ),
      );
    }

    if (_createUserUseCase == null || _getUsersUseCase == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to initialize dependencies'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeDependencies,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade100,
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _creating ? null : _createUser,
                  icon: _creating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: Text(_creating ? 'Creating...' : 'Create User'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${_users.length} Users',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('#${user.id}'),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Helper Widgets
// ============================================================================

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
