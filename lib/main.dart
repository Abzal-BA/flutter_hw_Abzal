import 'package:flutter/material.dart';
import 'y00_day09_flutter_project.dart';
import 'z00_day10_welcome_page.dart';
import 'z01_day11_counter_page.dart';
import 'z01_day12_login_page.dart';
import 'z01_day13_detail_screen.dart';
import 'z01_day14_task_list.dart';
import 'z01_day15_http_request.dart';
import 'z01_day16_persistent_counter.dart';
import 'z01_day17_provider_task_list.dart';
import 'z01_day18_theme_adaptive.dart';
import 'z01_day19_image_gallery.dart';
import 'z01_day20_movie_catalog.dart';
import 'z01_day21_ai_login_screen.dart';
import 'z01_day22_ai_code_analysis.dart';
import 'z01_day23_ai_development_workflow.dart';
import 'z01_day24_flutter_animations.dart';
import 'z01_day25_explicit_animations.dart';
import 'z01_day26_advanced_animations.dart';
import 'day_27/z01_day27_bloc_cubit.dart';
import 'day_28/z01_day28_dio_networking.dart';
import 'day_29/z01_day29_drift_database.dart';

// Day 09 Flutter - 01.12.2025
// Day 10 Flutter - 06.12.2025
// Day 11 Flutter - 07.12.2025
// Day 12 Flutter - 15.12.2025
// Day 13 Flutter - 16.12.2025
// Day 14 Flutter - 20.12.2025
// Day 15 Flutter - 25.12.2025
// Day 16 Flutter - 25.12.2025
// Day 17 Flutter - 13.01.2026
// Day 18 Flutter - 13.01.2026
// Day 19 Flutter - 13.01.2026
// Day 20 Flutter - 14.01.2026
// Day 21 Flutter - 22.01.2026
// Day 22 Flutter - 22.01.2026
// Day 23 Flutter - 25.01.2026
// Day 24 Flutter - 09.02.2026
// Day 25 Flutter - 10.02.2026
// Day 26 Flutter - 10.02.2026
// Day 27 Flutter - 10.02.2026
// Day 28 Flutter - 17.02.2026
// Day 29 Flutter - 17.02.2026

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 40, 80, 112),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return RepaintBoundary(child: child!);
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollPercentage);
  }

  void _updateScrollPercentage() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final newPercentage = maxScroll > 0 ? (currentScroll / maxScroll) : 0.0;
      if (mounted && (newPercentage - _scrollPercentage).abs() > 0.001) {
        setState(() {
          _scrollPercentage = newPercentage;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollPercentage);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToPosition(double position) {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final targetScroll = position * maxScroll;
      _scrollController.jumpTo(targetScroll.clamp(0.0, maxScroll));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abzal BAIKENOV - Home Work'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
      ),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification ||
                  notification is ScrollEndNotification) {
                _updateScrollPercentage();
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(right: 60, left: 16), // Space for scroll indicator and left padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              const SizedBox(height: 20),
              const Text(
                'Flutter Home Work',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 38, 64, 84).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '21 Lessons • Latest First',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 38, 64, 84),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _NavigationButton(
                title: '2026.02 Day 29 - Drift Database',
                page: Day29DriftDatabaseApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.02 Day 28 - Dio Networking',
                page: Day28DioNetworkingApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.02 Day 27 - flutter_bloc (BLoC/Cubit)',
                page: Day27BlocCubitApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.02 Day 26 - Advanced Animations',
                page: Day26AdvancedAnimationsApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.02 Day 25 - Explicit Animations',
                page: Day25ExplicitAnimationsApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.02 Day 24 - Flutter Animations',
                page: Day24AnimationsApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.01 Day 23 - AI Development Workflow',
                page: AIWorkflowApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.01 Day 22 - AI Code Analysis & Refactoring',
                page: CodeAnalysisDemo(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.01 Day 21 - AI-Generated Login Screen',
                page: LoginScreenApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.01 Day 20 - Movie Catalog App',
                page: MovieCatalogApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.01 Day 19 - Image Gallery',
                page: ImageGalleryApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.01 Day 18 - Theme & Adaptive Layout',
                page: ThemeAdaptiveApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2026.01 Day 17 - Provider Task List',
                page: ProviderTaskListApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2025.12 Day 16 - Persistent Counter',
                page: PersistentCounterPage(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2025.12 Day 15 - HTTP Request',
                page: PostsPage(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2025.12 Day 14 - Tasks List',
                page: TasksListScreen(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2025.12 Day 13 - Navigation Demo',
                page: MainScreen(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2025.12 Day 12 - Login Page',
                page: LoginPage(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2025.12 Day 11 - Counter Page',
                page: CounterPage(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2025.12 Day 10 - Welcome Page',
                page: WelcomeApp(),
              ),
              const SizedBox(height: 15),
              _NavigationButton(
                title: '2025.12 Day 9 - Flutter Project',
                page: HwApp(),
              ),
              const SizedBox(height: 20),
            ],
          ),
            ),
          ),
        ),
          // Custom scroll indicator
          Positioned(
            right: 16,
            top: 80,
            bottom: 16,
            child: Column(
              children: [
                // Up arrow
                GestureDetector(
                  onTap: _scrollToTop,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 38, 64, 84),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Scroll indicator bar
                Expanded(
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final localPosition = details.localPosition.dy;
                      final barHeight = box.size.height - 96; // Subtract arrows and spacing
                      final position = (localPosition - 48) / barHeight; // Adjust for top arrow
                      _scrollToPosition(position.clamp(0.0, 1.0));
                    },
                    onTapDown: (details) {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final localPosition = details.localPosition.dy;
                      final barHeight = box.size.height - 96;
                      final position = (localPosition - 48) / barHeight;
                      _scrollToPosition(position.clamp(0.0, 1.0));
                    },
                    child: Container(
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color.fromARGB(255, 38, 64, 84),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          children: [
                            // Background track
                            Container(
                              color: Colors.grey[300],
                            ),
                            // Filled portion
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: _scrollPercentage.clamp(0.05, 1.0), // Min 5% visible
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromARGB(255, 66, 165, 245),
                                        Color.fromARGB(255, 21, 101, 192),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Percentage text overlay
                            if (_scrollPercentage > 0.1)
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${(_scrollPercentage * 100).toInt()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Down arrow
                GestureDetector(
                  onTap: _scrollToBottom,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 38, 64, 84),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 20,
                    ),
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

class _NavigationButton extends StatelessWidget {
  final String title;
  final Widget page;

  const _NavigationButton({required this.title, required this.page});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
        ),
        child: Text(title),
      ),
    );
  }
}
