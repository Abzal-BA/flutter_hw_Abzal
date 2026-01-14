// ================================================================================
// Day 20 - Models: Movie data class with JSON serialization
// ================================================================================

class Movie {
  final String id;
  final String title;
  final String director;
  final int year;
  final String genre;
  final double rating;
  final String description;
  final String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.year,
    required this.genre,
    required this.rating,
    required this.description,
    required this.imageUrl,
  });

  // Copy with method for editing
  Movie copyWith({
    String? id,
    String? title,
    String? director,
    int? year,
    String? genre,
    double? rating,
    String? description,
    String? imageUrl,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      director: director ?? this.director,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Convert Movie to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'director': director,
      'year': year,
      'genre': genre,
      'rating': rating,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  // Create Movie from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      director: json['director'] as String,
      year: json['year'] as int,
      genre: json['genre'] as String,
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
