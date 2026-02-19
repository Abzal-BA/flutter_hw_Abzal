import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:practice_10/day_30/api_client.dart';
import 'package:practice_10/day_30/models.dart';
import 'package:practice_10/day_30/service_locator.dart';
import 'package:practice_10/day_30/use_cases.dart';

// ============================================================================
// Fake/Test Implementations (Manual Mocks)
// ============================================================================

class FakeApiClient implements ApiClient {
  final List<User> users;
  final Map<int, List<Post>> posts;
  bool shouldThrowError;
  int getUsersCallCount = 0;
  int createUserCallCount = 0;

  FakeApiClient({
    List<User>? users,
    Map<int, List<Post>>? posts,
    this.shouldThrowError = false,
  })  : users = users ??
            [
              User(id: 1, name: 'Test User', email: 'test@example.com'),
              User(id: 2, name: 'Another User', email: 'another@example.com'),
            ],
        posts = posts ??
            {
              1: [
                Post(id: 1, userId: 1, title: 'Test Post', body: 'Test Body'),
              ],
            };

  @override
  Future<List<User>> getUsers() async {
    getUsersCallCount++;
    if (shouldThrowError) {
      throw Exception('Network error');
    }
    return List.from(users);
  }

  @override
  Future<List<Post>> getPosts(int userId) async {
    if (shouldThrowError) {
      throw Exception('Network error');
    }
    return List.from(posts[userId] ?? []);
  }

  @override
  Future<User> createUser(String name, String email) async {
    createUserCallCount++;
    if (shouldThrowError) {
      throw Exception('API error');
    }
    final newUser = User(id: users.length + 1, name: name, email: email);
    users.add(newUser);
    return newUser;
  }
}

// ============================================================================
// Unit Tests with Dependency Injection
// ============================================================================

void main() {
  // ✅ Initialize Flutter bindings for tests
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Dependency Injection Tests', () {
    late FakeApiClient fakeApiClient;
    late SharedPreferences prefs;

    setUp(() async {
      fakeApiClient = FakeApiClient();
      
      // Setup mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    tearDown(() async {
      await resetServiceLocator();
    });

    test('GetUsersUseCase returns users from repository', () async {
      // Arrange: Setup with test dependencies
      await setupServiceLocatorForTesting(
        mockApiClient: fakeApiClient,
        mockPrefs: prefs,
      );

      // Get use case from service locator
      final useCase = getIt<GetUsersUseCase>();

      // Act: Execute use case
      final result = await useCase.execute();

      // Assert: Verify results
      expect(result.length, 2);
      expect(result[0].name, 'Test User');
      expect(result[1].email, 'another@example.com');
      expect(fakeApiClient.getUsersCallCount, 1);
    });

    test('CreateUserUseCase validates email format', () async {
      // Arrange
      await setupServiceLocatorForTesting(
        mockApiClient: fakeApiClient,
        mockPrefs: prefs,
      );

      final useCase = getIt<CreateUserUseCase>();

      // Act & Assert: Invalid email should throw
      expect(
        () => useCase.execute('John', 'invalid-email'),
        throwsA(isA<Exception>()),
      );
    });

    test('CreateUserUseCase validates name length', () async {
      // Arrange
      await setupServiceLocatorForTesting(
        mockApiClient: fakeApiClient,
        mockPrefs: prefs,
      );

      final useCase = getIt<CreateUserUseCase>();

      // Act & Assert: Short name should throw
      expect(
        () => useCase.execute('A', 'valid@email.com'),
        throwsA(isA<Exception>()),
      );
    });

    test('CreateUserUseCase creates user with valid data', () async {
      // Arrange
      await setupServiceLocatorForTesting(
        mockApiClient: fakeApiClient,
        mockPrefs: prefs,
      );

      final useCase = getIt<CreateUserUseCase>();

      // Act
      final result = await useCase.execute('New User', 'new@example.com');

      // Assert
      expect(result.name, 'New User');
      expect(result.email, 'new@example.com');
      expect(fakeApiClient.createUserCallCount, 1);
      expect(fakeApiClient.users.length, 3); // Started with 2, added 1
    });

    test('FavoriteUserUseCase saves and retrieves favorite', () async {
      // Arrange
      await setupServiceLocatorForTesting(
        mockApiClient: fakeApiClient,
        mockPrefs: prefs,
      );

      final useCase = getIt<FavoriteUserUseCase>();

      // Act
      await useCase.setFavorite(42);
      final result = await useCase.getFavorite();

      // Assert
      expect(result, 42);
    });

    test('Repository handles API errors gracefully', () async {
      // Arrange: Use FakeApiClient that throws errors
      final errorClient = FakeApiClient(shouldThrowError: true);
      
      await setupServiceLocatorForTesting(
        mockApiClient: errorClient,
        mockPrefs: prefs,
      );

      final useCase = getIt<GetUsersUseCase>();

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
    });

    test('GetUserPostsUseCase returns posts for specific user', () async {
      // Arrange
      await setupServiceLocatorForTesting(
        mockApiClient: fakeApiClient,
        mockPrefs: prefs,
      );

      final useCase = getIt<GetUserPostsUseCase>();

      // Act
      final result = await useCase.execute(1);

      // Assert
      expect(result.length, 1);
      expect(result[0].userId, 1);
      expect(result[0].title, 'Test Post');
    });

    test('Service locator provides same singleton instance', () async {
      // Arrange
      await setupServiceLocatorForTesting(
        mockApiClient: fakeApiClient,
        mockPrefs: prefs,
      );

      // Act: Get API client twice
      final client1 = getIt<ApiClient>();
      final client2 = getIt<ApiClient>();

      // Assert: Should be the same instance (singleton)
      expect(identical(client1, client2), true);
    });

    test('Service locator provides different factory instances', () async {
      // Arrange
      await setupServiceLocatorForTesting(
        mockApiClient: fakeApiClient,
        mockPrefs: prefs,
      );

      // Act: Get use case twice
      final useCase1 = getIt<GetUsersUseCase>();
      final useCase2 = getIt<GetUsersUseCase>();

      // Assert: Should be different instances (factory)
      expect(identical(useCase1, useCase2), false);
    });
  });
}
