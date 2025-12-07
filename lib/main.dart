import 'package:flutter/material.dart';
import 'y00_DAY09_flutterProject.dart';
import 'z00_DAY10_welcomePage.dart';
import 'z01_DAY11_counterPage.dart';


// Day 09 Flutter - 01.12.2025
// Day 10 Flutter - 06.12.2025
// Day 11 Flutter - 07.12.2025


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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 40, 80, 112)),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) { return RepaintBoundary(child: child!); },
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
          ],
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String title;
  final Widget page;
  
  const _NavigationButton({
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Text(title),
    );
  }
}
