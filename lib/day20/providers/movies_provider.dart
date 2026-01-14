// ================================================================================
// Day 20 - Provider: Movies state management with persistent storage
// ================================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class MoviesProvider extends ChangeNotifier {
  static const String _storageKey = 'movies_data';
  
  List<Movie> _movies = [];
  SharedPreferences? _prefs;

  List<Movie> get movies => [..._movies];

  // Initialize provider and load saved movies
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadMovies();
  }

  // Load movies from shared preferences
  Future<void> _loadMovies() async {
    try {
      final String? moviesJson = _prefs?.getString(_storageKey);
      
      if (moviesJson != null && moviesJson.isNotEmpty) {
        // Load from storage
        final List<dynamic> decodedList = jsonDecode(moviesJson);
        _movies = decodedList.map((item) => Movie.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        // Load default movies if no saved data
        _loadDefaultMovies();
      }
    } catch (e) {
      print('Error loading movies: $e');
      _loadDefaultMovies();
    }
    notifyListeners();
  }

  // Load default sample movies
  void _loadDefaultMovies() {
    _movies = [
    Movie(
      id: '1',
      title: 'The Shawshank Redemption',
      director: 'Frank Darabont',
      year: 1994,
      genre: 'Drama',
      rating: 9.3,
      description: 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
      imageUrl: 'https://m.media-amazon.com/images/M/MV5BNzUzNzI0MjAxMl5BMl5BanBnXkFtZTgwMjQ2MjEyMDE@._V1_QL75_UX306_.jpg',
    ),
    Movie(
      id: '2',
      title: 'The Godfather',
      director: 'Francis Ford Coppola',
      year: 1972,
      genre: 'Crime',
      rating: 9.2,
      description: 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
      imageUrl: 'https://media.gettyimages.com/id/505997107/photo/the-godfather-a-1972-american-crime-film-starring-marlon-brando-and-al-pacino.jpg?s=612x612&w=0&k=20&c=OpLkwDrISkiB_a2CMrjnOjaE9K0FHhSZ9ttDCgNUXTQ=',
    ),
    Movie(
      id: '3',
      title: 'The Dark Knight',
      director: 'Christopher Nolan',
      year: 2008,
      genre: 'Action',
      rating: 9.0,
      description: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests.',
      imageUrl: 'https://media.gettyimages.com/id/53078616/photo/washington-batman-unlike-anything-youve-seen-before-christopher-nolans-batman-begins-explores.jpg?s=612x612&w=0&k=20&c=eqN72_44BcWurlP5lezXkIMrvIroQ-MhKP8LuDmwOUk=',
    ),
    Movie(
      id: '4',
      title: 'Inception',
      director: 'Christopher Nolan',
      year: 2010,
      genre: 'Sci-Fi',
      rating: 8.8,
      description: 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea.',
      imageUrl: 'https://m.media-amazon.com/images/M/MV5BMTM0MjUzNjkwMl5BMl5BanBnXkFtZTcwNjY0OTk1Mw@@._V1_QL75_UX298_.jpg',
    ),
    ];
  }

  Movie? findById(String id) {
    try {
      return _movies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  // Save movies to shared preferences
  Future<void> _saveMovies() async {
    try {
      final String moviesJson = jsonEncode(
        _movies.map((movie) => movie.toJson()).toList(),
      );
      await _prefs?.setString(_storageKey, moviesJson);
    } catch (e) {
      print('Error saving movies: $e');
    }
  }

  void addMovie(Movie movie) {
    _movies.add(movie);
    _saveMovies();
    notifyListeners();
  }

  void updateMovie(String id, Movie updatedMovie) {
    final index = _movies.indexWhere((movie) => movie.id == id);
    if (index != -1) {
      _movies[index] = updatedMovie;
      _saveMovies();
      notifyListeners();
    }
  }

  void deleteMovie(String id) {
    _movies.removeWhere((movie) => movie.id == id);
    _saveMovies();
    notifyListeners();
  }
}
