import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'repository.dart';
import 'use_cases.dart';

// ============================================================================
// Service Locator (Dependency Injection Container)
// ============================================================================

final getIt = GetIt.instance;

/// Initialize all dependencies
/// This is called before runApp() to ensure async dependencies are ready
Future<void> setupServiceLocator() async {
  // ============================================================================
  // 1. Async Initialization (SharedPreferences, Firebase, etc.)
  // ============================================================================
  
  print('🔧 Initializing Service Locator...');
  
  // Async dependency: SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  print('✅ SharedPreferences initialized');

  // ============================================================================
  // 2. API Client - Switch between Mock and Real based on build mode
  // ============================================================================
  
  if (kDebugMode) {
    // Debug mode: Use Mock API
    getIt.registerLazySingleton<ApiClient>(
      () => MockApiClient(),
    );
    print('✅ ApiClient registered (MOCK - Debug Mode)');
  } else {
    // Release mode: Use Real API
    getIt.registerLazySingleton<ApiClient>(
      () => RealApiClient(),
    );
    print('✅ ApiClient registered (REAL - Release Mode)');
  }

  // ============================================================================
  // 3. Repository
  // ============================================================================
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      apiClient: getIt<ApiClient>(),
      prefs: getIt<SharedPreferences>(),
    ),
  );
  print('✅ UserRepository registered');

  // ============================================================================
  // 4. Use Cases
  // ============================================================================
  
  getIt.registerFactory<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerFactory<GetUserPostsUseCase>(
    () => GetUserPostsUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerFactory<CreateUserUseCase>(
    () => CreateUserUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerFactory<FavoriteUserUseCase>(
    () => FavoriteUserUseCase(getIt<UserRepository>()),
  );
  
  print('✅ Use Cases registered');
  print('🎉 Service Locator setup complete!\n');
}

/// Reset all dependencies (useful for testing)
Future<void> resetServiceLocator() async {
  await getIt.reset();
  print('🔄 Service Locator reset');
}

/// Setup with custom dependencies (for testing)
Future<void> setupServiceLocatorForTesting({
  required ApiClient mockApiClient,
  required SharedPreferences mockPrefs,
}) async {
  await getIt.reset();
  
  getIt.registerSingleton<SharedPreferences>(mockPrefs);
  getIt.registerLazySingleton<ApiClient>(() => mockApiClient);
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      apiClient: getIt<ApiClient>(),
      prefs: getIt<SharedPreferences>(),
    ),
  );
  
  getIt.registerFactory<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerFactory<GetUserPostsUseCase>(
    () => GetUserPostsUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerFactory<CreateUserUseCase>(
    () => CreateUserUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerFactory<FavoriteUserUseCase>(
    () => FavoriteUserUseCase(getIt<UserRepository>()),
  );
  
  print('✅ Test dependencies registered');
}
