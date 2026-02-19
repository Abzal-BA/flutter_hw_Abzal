import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'models.dart';

// ============================================================================
// Repository Interface
// ============================================================================

abstract class UserRepository {
  Future<List<User>> fetchUsers();
  Future<List<Post>> fetchUserPosts(int userId);
  Future<User> addUser(String name, String email);
  Future<void> saveFavoriteUserId(int userId);
  Future<int?> getFavoriteUserId();
}

// ============================================================================
// Repository Implementation
// ============================================================================

class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;
  final SharedPreferences prefs;

  UserRepositoryImpl({
    required this.apiClient,
    required this.prefs,
  });

  @override
  Future<List<User>> fetchUsers() async {
    try {
      return await apiClient.getUsers();
    } catch (e) {
      throw Exception('Repository: Failed to fetch users - $e');
    }
  }

  @override
  Future<List<Post>> fetchUserPosts(int userId) async {
    try {
      return await apiClient.getPosts(userId);
    } catch (e) {
      throw Exception('Repository: Failed to fetch posts - $e');
    }
  }

  @override
  Future<User> addUser(String name, String email) async {
    if (name.isEmpty || email.isEmpty) {
      throw Exception('Name and email cannot be empty');
    }
    
    try {
      return await apiClient.createUser(name, email);
    } catch (e) {
      throw Exception('Repository: Failed to create user - $e');
    }
  }

  @override
  Future<void> saveFavoriteUserId(int userId) async {
    await prefs.setInt('favorite_user_id', userId);
  }

  @override
  Future<int?> getFavoriteUserId() async {
    return prefs.getInt('favorite_user_id');
  }
}
