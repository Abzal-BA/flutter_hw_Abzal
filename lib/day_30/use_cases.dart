import 'models.dart';
import 'repository.dart';

// ============================================================================
// Use Cases
// ============================================================================

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<User>> execute() async {
    return await repository.fetchUsers();
  }
}

class GetUserPostsUseCase {
  final UserRepository repository;

  GetUserPostsUseCase(this.repository);

  Future<List<Post>> execute(int userId) async {
    return await repository.fetchUserPosts(userId);
  }
}

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<User> execute(String name, String email) async {
    // Business logic: validate email format
    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }
    
    if (name.length < 2) {
      throw Exception('Name must be at least 2 characters');
    }
    
    return await repository.addUser(name, email);
  }
}

class FavoriteUserUseCase {
  final UserRepository repository;

  FavoriteUserUseCase(this.repository);

  Future<void> setFavorite(int userId) async {
    await repository.saveFavoriteUserId(userId);
  }

  Future<int?> getFavorite() async {
    return await repository.getFavoriteUserId();
  }
}
