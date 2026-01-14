// ================================================================================
// ==-= Flutter - Home work Lesson 20 =-=
// ================================================================================
// 1) Choose an idea for a mini-application (task list, notes app, or movie catalog) and create a new Flutter project for this idea.
// 2) Describe requirements: list which screens are needed (list screen, details screen, add/edit screen), and what data will be used.
// 3) Set up project structure: create folders (models, screens, providers) to separate data classes, UI screens, and business logic.
// 4) Implement the main screen with a list of items: use ListView to display the list (fill with test data for now).
// 5) Create a details screen that displays detailed information about the selected list item.
// 6) Set up navigation: when clicking on a list item, execute Navigator.push to open details screen, passing selected item data.
// 7) Implement state management through Provider. Create ChangeNotifier for the list and wrap the app in ChangeNotifierProvider.
// 8) Check basic functionality: run the app, make sure list displays, navigation works and data passes correctly.
// 9) Design the interface: add AppBar with title, use ListTile or Card for list items, add icons and apply ThemeData.
// 10) Extend functionality: implement adding new items (through form screen or dialog), deletion or editing. Test all features.

// ================================================================================
// Project: Movie Catalog App
// ================================================================================
// Requirements:
// - Screens: Movie List, Movie Details, Add/Edit Movie
// - Data: Movie (id, title, director, year, genre, rating, description, imageUrl)
// - Features: View, Add, Edit, Delete movies
// 
// Project Structure:
// - models/ - Movie data class
// - screens/ - UI screens (list, details, add/edit)
// - providers/ - MoviesProvider for state management
// ================================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'day20/providers/movies_provider.dart';
import 'day20/screens/movie_list_screen.dart';

class MovieCatalogApp extends StatefulWidget {
  const MovieCatalogApp({super.key});

  @override
  State<MovieCatalogApp> createState() => _MovieCatalogAppState();
}

class _MovieCatalogAppState extends State<MovieCatalogApp> {
  late MoviesProvider _moviesProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    _moviesProvider = MoviesProvider();
    await _moviesProvider.init();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ChangeNotifierProvider.value(
      value: _moviesProvider,
      child: MaterialApp(
        title: 'Movie Catalog',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 40, 80, 112),
          ),
        ),
        home: const MovieListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
