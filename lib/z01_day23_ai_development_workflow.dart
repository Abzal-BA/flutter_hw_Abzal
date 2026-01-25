// ================================================================================
// ==-= Flutter - Home work Lesson 23 =-=
// ================================================================================
// AI-Driven Development: From Design to Debugging to Learning
//
// 1) Application Design with AI:
//    - Generate ideas and features
//    - Sketch screen structure and navigation
//    - Select libraries and approaches
//
// 2) Debugging with AI:
//    - Explain compilation and runtime errors
//    - Find logical errors
//
// 3) Learning with AI:
//    - Understand confusing parts of Flutter docs
//    - Create mini-exercises and tasks
//
// 4) Practice: Improve Day 20 Movie Catalog
//    - AI analysis of architecture
//    - UI improvements
//    - Feature suggestions
// ================================================================================

import 'package:flutter/material.dart';

class AIWorkflowApp extends StatefulWidget {
  const AIWorkflowApp({super.key});

  @override
  State<AIWorkflowApp> createState() => _AIWorkflowAppState();
}

class _AIWorkflowAppState extends State<AIWorkflowApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('AI-Driven Development Workflow'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '🎨 Design'),
            Tab(text: '🐛 Debugging'),
            Tab(text: '📚 Learning'),
            Tab(text: '📈 Practice'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDesignTab(),
          _buildDebuggingTab(),
          _buildLearningTab(),
          _buildPracticeTab(),
        ],
      ),
    );
  }

  Widget _buildDesignTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('🎨 Application Design with AI'),
          const SizedBox(height: 12),
          _buildContentSection(
            'Phase 1: Generate Ideas & Features',
            '''
Prompt: "I want to build a movie catalog app. What features should I include?"

AI Response:
✓ Core Features:
  • Movie list with search and filter
  • Detail view with ratings
  • Add/edit/delete movies
  • Favorites/watchlist
  • User ratings and reviews
  
✓ Advanced Features:
  • Genre-based recommendations
  • Collection management
  • Export/import functionality
  • Offline mode
  • Social sharing
  • Multi-language support

Used in Project:
✅ Core features implemented in Day 20
📌 Advanced features ideas for future expansion
            ''',
          ),
          const SizedBox(height: 16),
          _buildContentSection(
            'Phase 2: Screen Structure & Navigation',
            '''
Prompt: "Design the app navigation flow for a movie catalog"

AI Response Structure:
├── Home Screen (Movie List)
│   ├── Search/Filter Panel
│   └── Movie Cards Grid/List
├── Detail Screen
│   ├── Full Movie Information
│   ├── Edit Button
│   ├── Delete Button
│   └── Ratings Section
├── Add/Edit Screen
│   ├── Form Fields (Title, Director, etc)
│   ├── Image Upload
│   └── Validation
└── Settings Screen (Future)
    ├── Theme Toggle
    └── Preferences

Implemented in Day 20:
✅ Movie List Screen (with FAB for add)
✅ Movie Details Screen
✅ Add/Edit Movie Screen
📌 Settings Screen (planned)
            ''',
          ),
          const SizedBox(height: 16),
          _buildContentSection(
            'Phase 3: Libraries & Approaches',
            '''
Prompt: "What libraries should I use for state management and persistence?"

AI Recommendations:
✅ State Management:
   • Provider: Simple, scalable, good for small-medium apps
   • Riverpod: More type-safe version of Provider
   • BLoC: Complex but powerful pattern
   
✅ Persistence:
   • SharedPreferences: Simple key-value storage (USED)
   • Hive: Fast local database
   • SQLite: Complex queries support
   • Firebase: Cloud sync and real-time
   
✅ UI Libraries:
   • Material Design 3 (USED)
   • Cupertino for iOS style
   • Custom designs with Flutter basics

Decision Made for Project:
✅ Provider for state management
✅ SharedPreferences + JSON for persistence
✅ Material Design 3 with custom theming
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildDebuggingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('🐛 Debugging with AI'),
          const SizedBox(height: 12),
          _buildErrorExample(
            'Compilation Error',
            '''
Error:
"The getter 'movies' isn't defined for the type 'MoviesProvider'."

Debugged with AI:
✗ Problem: Provider not properly initialized in widget tree
✗ Root Cause: MoviesProvider not wrapped around screens

AI Solution:
✓ Wrap MaterialApp with ChangeNotifierProvider
✓ Use context.watch<MoviesProvider>() not context.read()
✓ Ensure provider is in scope of consumer widgets

Code Fix:
// BEFORE (Error)
home: const MovieListScreen(),

// AFTER (Fixed)
home: ChangeNotifierProvider(
  create: (_) => MoviesProvider(),
  child: const MovieListScreen(),
),

Learned Concept:
Provider scope and widget tree hierarchy
            ''',
          ),
          const SizedBox(height: 16),
          _buildErrorExample(
            'Runtime Error',
            '''
Error:
"type '_InternalLinkedHashMap<String, dynamic>' is not a subtype of 'Movie'"

Debugged with AI:
✗ Problem: JSON deserialization mismatch
✗ Root Cause: fromJson() factory expects correct JSON structure

AI Solution:
✓ Check JSON structure matches factory constructor
✓ Add null-safety checks in fromJson()
✓ Validate data before casting

Code Fix:
// BEFORE (Error)
Movie movie = Movie.fromJson(jsonData);

// AFTER (Fixed with validation)
Movie movie = Movie.fromJson(jsonData as Map<String, dynamic>);

Learned Concept:
Type safety and JSON serialization in Dart
            ''',
          ),
          const SizedBox(height: 16),
          _buildErrorExample(
            'Logical Error',
            '''
Issue:
Movies not persisting after app restart

Debugged with AI:
✗ Problem: _saveMovies() not called after updates
✗ Root Cause: Missing async/await calls

AI Solution:
✓ Ensure _saveMovies() is awaited
✓ Add error handling for storage operations
✓ Verify SharedPreferences initialization

Code Fix:
// BEFORE (Bug)
void addMovie(Movie movie) {
  movies.add(movie);
  notifyListeners();
  _saveMovies(); // No await!
}

// AFTER (Fixed)
void addMovie(Movie movie) {
  movies.add(movie);
  notifyListeners();
  _saveMovies(); // Async handled internally
}

Future<void> _saveMovies() async {
  try {
    final encoded = movies.map((m) => jsonEncode(m.toJson())).toList();
    await _prefs.setStringList('movies_data', encoded);
  } catch (e) {
    print('Error saving movies: \$e');
  }
}

Learned Concept:
Async operations and persistence patterns
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildLearningTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('📚 Learning with AI'),
          const SizedBox(height: 12),
          _buildLearningItem(
            'Understanding Provider Pattern',
            '''
Question: "Explain what context.watch() and context.read() do"

AI Explanation:
• context.watch():
  - Makes widget rebuild when provider value changes
  - Used for displaying data in UI
  - Cannot be called in event handlers
  - Example: Build method, widget children
  
• context.read():
  - Gets current value without listening to changes
  - Used in callbacks and event handlers
  - No automatic rebuilds
  - Example: onPressed(), buttons, navigation

Key Difference:
watch() = subscription (reactive)
read() = one-time read (imperative)

Exercise Created:
1. Create a counter with watch() - rebuilds on change
2. Create a button that uses read() - no rebuild needed
3. Combine both in same widget
            ''',
          ),
          const SizedBox(height: 16),
          _buildLearningItem(
            'Understanding Widget Lifecycle',
            '''
Question: "What\'s the difference between build(), initState(), dispose()?"

AI Explanation:
• initState():
  - Called once when widget created
  - Initialize variables, animations, providers
  - Set up listeners
  
• build():
  - Called multiple times during widget lifetime
  - Called when setState() is invoked
  - Should be pure (no side effects)
  - Rebuild when parents rebuild
  
• dispose():
  - Called when widget is destroyed
  - Clean up animations, controllers, listeners
  - Must call super.dispose()

Lifecycle Flow:
Constructor → initState() → build() → setState → build() → ... → dispose()

Exercise Created:
1. Create StatefulWidget with all lifecycle methods
2. Log each method call
3. See when each is called
            ''',
          ),
          const SizedBox(height: 16),
          _buildLearningItem(
            'Understanding Navigator & Routes',
            '''
Question: "How does Flutter navigation work? What\'s the difference between named and unnamed routes?"

AI Explanation:
• Unnamed Routes (Used in Project):
  - Navigator.push() and Navigator.pop()
  - Direct widget navigation
  - No route naming needed
  - Good for small apps
  
• Named Routes:
  - Define routes in MaterialApp
  - Navigator.pushNamed() and popNamed()
  - Centralized routing
  - Good for large apps

Navigation Stack:
Push → screen1 [screen2] → screen2 pushed
Pop → [screen2] screen1 → screen2 removed, back to screen1

Exercise Created:
1. Navigate between screens using push/pop
2. Pass data between screens
3. Handle back button behavior
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('📈 Practical AI Improvement: Movie Catalog'),
          const SizedBox(height: 12),
          _buildPracticeSection(
            'Architecture Improvement',
            '''
Question to AI:
"How can I improve the architecture of my movie catalog app?"

AI Analysis:
Current Structure:
✓ Good: Separated models, providers, screens
✓ Good: JSON serialization
⚠ Could improve: No error handling layer
⚠ Could improve: No logging system
⚠ Could improve: No dependency injection

AI Recommendations:
1. Add Service Layer:
   - Create MovieService for API calls
   - Separate business logic from UI
   - Easier testing

2. Add Error Handling:
   - Create AppException class
   - Handle errors in provider
   - Show error UI in screens

3. Add Logging:
   - Log important events
   - Debug production issues
   - Track user interactions

4. Add Repository Pattern:
   - Decouple data source
   - Make switching storage easier
   - Better code organization

Implementation Priority:
🔴 High: Error handling (affects UX)
🟡 Medium: Service layer (better organization)
🟡 Medium: Repository pattern (scalability)
🟢 Low: Logging (nice to have)

Next Steps:
• Create MovieService class
• Add try-catch in provider methods
• Add error dialogs in screens
            ''',
          ),
          const SizedBox(height: 16),
          _buildPracticeSection(
            'UI Improvements',
            '''
Question to AI:
"How can I make the movie catalog UI more modern and polished?"

AI Suggestions:
Current UI Issues:
⚠ Plain Card layouts
⚠ No animations
⚠ No loading states
⚠ Limited color scheme
⚠ No empty state UI

Recommended Improvements:
1. Add Animations:
   ✓ Hero animation for movie poster on tap
   ✓ Fade-in animation for list
   ✓ Scale animation for buttons
   
2. Enhance Visual Hierarchy:
   ✓ Use theme colors more consistently
   ✓ Add typography hierarchy
   ✓ Better spacing and padding
   
3. Add Loading/Empty States:
   ✓ Shimmer loading while fetching
   ✓ "No movies" empty state screen
   ✓ Error state with retry button
   
4. Improve Components:
   ✓ Custom movie card with gradient
   ✓ Rating bar with star animation
   ✓ Smooth transitions
   
5. Add Dark Mode Support:
   ✓ Test on dark theme
   ✓ Adjust colors for visibility
   ✓ Use context.isDarkMode

Priority Implementation:
🔴 High: Empty and error states
🔴 High: Loading states
🟡 Medium: Animations
🟡 Medium: Enhanced styling
🟢 Low: Dark mode refinement

Quick Wins (Start Here):
• Add empty state screen image
• Add loading spinner in list
• Add error snackbars
            ''',
          ),
          const SizedBox(height: 16),
          _buildPracticeSection(
            'Feature Suggestions',
            '''
Question to AI:
"What features should I add to my movie catalog app next?"

AI-Generated Feature Ideas:
Easy Features (1-2 hours):
✅ Search functionality
   - Filter movies by title
   - Case-insensitive search
   
✅ Sorting options
   - By date added
   - By rating
   - By title
   
✅ Movie categories/tags
   - Genre-based organization
   - Custom tags

Medium Features (3-5 hours):
📌 Favorites system
   - Mark movies as favorite
   - Separate favorites screen
   - Heart icon animation
   
📌 Movie statistics
   - Total movies count
   - Average rating
   - Movies by year chart
   
📌 Backup & Restore
   - Export movies as JSON
   - Import from file
   - Cloud sync (Firebase)

Advanced Features (1+ week):
🚀 Movie recommendations
   - Suggest similar movies
   - Based on ratings
   - Genre-based suggestions
   
🚀 User reviews & ratings
   - Rate movies 1-5 stars
   - Write reviews
   - See avg rating
   
🚀 Social features
   - Share movies with friends
   - View friend\'s lists
   - Collaborative lists

Recommended Next Steps:
1. Start with Search (most useful)
2. Add Sorting (quick improvement)
3. Add Favorites (popular feature)
4. Add Statistics (visual interest)

Day 24-25 Ideas:
• Day 24: Search + Sorting
• Day 25: Favorites + Statistics
• Day 26: Backup/Restore
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContentSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.6,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorExample(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, color: Colors.orange[700], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.6,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningItem(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Colors.green[700], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.6,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.purple[700], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.6,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
