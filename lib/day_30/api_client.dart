import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

// ============================================================================
// API Client Interface
// ============================================================================

abstract class ApiClient {
  Future<List<User>> getUsers();
  Future<List<Post>> getPosts(int userId);
  Future<User> createUser(String name, String email);
}

// ============================================================================
// Real API Implementation
// ============================================================================

class RealApiClient implements ApiClient {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  @override
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  @override
  Future<List<Post>> getPosts(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts?userId=$userId'),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  @override
  Future<User> createUser(String name, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email}),
    );
    
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user: ${response.statusCode}');
    }
  }
}

// ============================================================================
// Mock API Implementation (for testing/development)
// ============================================================================

class MockApiClient implements ApiClient {
  // Simulated delay to mimic network
  final Duration delay;

  MockApiClient({this.delay = const Duration(milliseconds: 500)});

  final List<User> _mockUsers = [
    User(id: 1, name: 'John Doe', email: 'john@example.com'),
    User(id: 2, name: 'Jane Smith', email: 'jane@example.com'),
    User(id: 3, name: 'Bob Johnson', email: 'bob@example.com'),
  ];

  final Map<int, List<Post>> _mockPosts = {
    1: [
      Post(
        id: 1,
        userId: 1,
        title: 'First Post',
        body: 'This is the first mock post',
      ),
      Post(
        id: 2,
        userId: 1,
        title: 'Second Post',
        body: 'This is the second mock post',
      ),
    ],
    2: [
      Post(
        id: 3,
        userId: 2,
        title: 'Jane\'s Post',
        body: 'Post by Jane',
      ),
    ],
    3: [
      Post(
        id: 4,
        userId: 3,
        title: 'Bob\'s Thoughts',
        body: 'Random thoughts from Bob',
      ),
    ],
  };

  @override
  Future<List<User>> getUsers() async {
    await Future.delayed(delay);
    return List.from(_mockUsers);
  }

  @override
  Future<List<Post>> getPosts(int userId) async {
    await Future.delayed(delay);
    return List.from(_mockPosts[userId] ?? []);
  }

  @override
  Future<User> createUser(String name, String email) async {
    await Future.delayed(delay);
    final newUser = User(
      id: _mockUsers.length + 1,
      name: name,
      email: email,
    );
    _mockUsers.add(newUser);
    return newUser;
  }
}
