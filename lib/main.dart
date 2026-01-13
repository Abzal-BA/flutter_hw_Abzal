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

// Day 09 Flutter - 01.12.2025
// Day 10 Flutter - 06.12.2025
// Day 11 Flutter - 07.12.2025
// Day 12 Flutter - 15.12.2025
// Day 13 Flutter - 16.12.2025
// Day 14 Flutter - 20.12.2025
// Day 15 Flutter - 25.12.2025
// Day 16 Flutter - 25.12.2025
// Day 17 Flutter - 13.01.2026

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abzal BAIKENOV - Home Work'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flutter Home Work',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _NavigationButton(
              title: '2025.12 Day 9 - Flutter Project',
              page: HwApp(),
            ),
            const SizedBox(height: 15),
            _NavigationButton(
              title: '2025.12 Day 10 - Welcome Page',
              page: WelcomeApp(),
            ),
            const SizedBox(height: 15),
            _NavigationButton(
              title: '2025.12 Day 11 - Counter Page',
              page: CounterPage(),
            ),
            const SizedBox(height: 15),
            _NavigationButton(
              title: '2025.12 Day 12 - Login Page',
              page: LoginPage(),
            ),
            const SizedBox(height: 15),
            _NavigationButton(
              title: '2025.12 Day 13 - Navigation Demo',
              page: MainScreen(),
            ),
            const SizedBox(height: 15),
            _NavigationButton(
              title: '2025.12 Day 14 - Tasks List',
              page: TasksListScreen(),
            ),
            const SizedBox(height: 15),
            _NavigationButton(
              title: '2025.12 Day 15 - HTTP Request',
              page: PostsPage(),
            ),
            const SizedBox(height: 15),
            _NavigationButton(
              title: '2025.12 Day 16 - Persistent Counter',
              page: PersistentCounterPage(),
            ),
            const SizedBox(height: 15),
            _NavigationButton(
              title: '2026.01 Day 17 - Provider Task List',
              page: ProviderTaskListApp(),
            ),
          ],
        ),
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
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Text(title),
    );
  }
}
