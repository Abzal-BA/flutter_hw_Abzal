// ============================================================================
// Day 31: Go Router Configuration
// ============================================================================
// go_router: Declarative routing for Flutter
// Best practices for navigation in modern Flutter apps
//
// 🎯 BENEFITS:
// ✅ Type-safe route parameters
// ✅ Deep linking support (web URLs)
// ✅ Nested navigation
// ✅ Route guards/redirects
// ✅ Named routes with parameters
// ✅ Better error handling
// ✅ Browser back button support (web)
//
// 🔧 CONCEPTS:
// - GoRoute: Defines a route
// - GoRouter: Main router configuration
// - context.go(): Navigate and replace
// - context.push(): Navigate and keep in stack
// - context.pop(): Go back
// - Extra parameters: Pass complex objects
// - Query parameters: URL-friendly params
//
// 🚀 ROUTES IN THIS DEMO:
// 1. /products - Products list (ListView with images)
// 2. /products/:id - Product details (with id parameter)
// 3. /profile/:userId - User profile (with userId + query params)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models.dart';
import 'screens/products_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';

// ============================================================================
// ROUTER CONFIGURATION
// ============================================================================
// Global router instance - can be accessed from anywhere

class AppRouter {
  // ============================================================
  // Route Names (Constants for type safety)
  // ============================================================
  // Using constants prevents typos in route names
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String profile = '/profile/:userId';

  // ============================================================
  // Router Instance
  // ============================================================
  // Configure all routes, redirects, and error handling
  static final GoRouter router = GoRouter(
    // ============================================================
    // Initial route (first screen shown)
    // ============================================================
    initialLocation: products,

    // ============================================================
    // Error handling
    // ============================================================
    // Shown when route is not found (404)
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('404 - Page Not Found'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Route not found: ${state.uri.path}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(products),
              child: const Text('Go to Products'),
            ),
          ],
        ),
      ),
    ),

    // ============================================================
    // Route Definitions
    // ============================================================
    routes: [
      // ===========================================================
      // ROUTE 1: Products List
      // ===========================================================
      // Path: /products
      // Simple route without parameters
      GoRoute(
        path: products,
        name: 'products',
        builder: (context, state) => const ProductsScreen(),
      ),

      // ===========================================================
      // ROUTE 2: Product Details
      // ===========================================================
      // Path: /products/:id
      // Demonstrates path parameters
      // Example: /products/123
      GoRoute(
        path: productDetail,
        name: 'product-detail',
        builder: (context, state) {
          // ============================================
          // Extract path parameter
          // ============================================
          // Get 'id' from URL path
          final idString = state.pathParameters['id'];
          final productId = int.tryParse(idString ?? '');

          // ============================================
          // Extract extra data (complex objects)
          // ============================================
          // Pass whole Product object via extra
          // This avoids re-fetching data
          final product = state.extra as Product?;

          // Validation
          if (productId == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Invalid Product')),
              body: const Center(
                child: Text('Invalid product ID'),
              ),
            );
          }

          return ProductDetailScreen(
            productId: productId,
            product: product,
          );
        },
      ),

      // ===========================================================
      // ROUTE 3: User Profile
      // ===========================================================
      // Path: /profile/:userId?tab=posts&sort=recent
      // Demonstrates:
      // - Path parameters (:userId)
      // - Query parameters (?tab=posts&sort=recent)
      // - Extra data (User object)
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) {
          // ============================================
          // Extract path parameter
          // ============================================
          final userIdString = state.pathParameters['userId'];
          final userId = int.tryParse(userIdString ?? '');

          // ============================================
          // Extract query parameters
          // ============================================
          // URL: /profile/123?tab=posts&sort=recent
          final tab = state.uri.queryParameters['tab'] ?? 'info';
          final sort = state.uri.queryParameters['sort'] ?? 'recent';

          // ============================================
          // Extract extra data (User object)
          // ============================================
          final user = state.extra as User?;

          // Validation
          if (userId == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Invalid User')),
              body: const Center(
                child: Text('Invalid user ID'),
              ),
            );
          }

          return ProfileScreen(
            userId: userId,
            user: user,
            initialTab: tab,
            sortOrder: sort,
          );
        },
      ),
    ],

    // ============================================================
    // Optional: Redirect logic
    // ============================================================
    // Example: Redirect to login if not authenticated
    // Uncomment and customize as needed:
    /*
    redirect: (context, state) {
      // Check authentication status
      final isAuthenticated = false; // Replace with real check
      final isGoingToLogin = state.uri.path == '/login';

      if (!isAuthenticated && !isGoingToLogin) {
        return '/login';
      }
      
      if (isAuthenticated && isGoingToLogin) {
        return '/products';
      }

      return null; // No redirect
    },
    */

    // ============================================================
    // Optional: Listeners
    // ============================================================
    // Track navigation events for analytics
    // observers: [NavigationObserver()],
  );
}

// ============================================================================
// NAVIGATION HELPER EXTENSIONS
// ============================================================================
// Convenient methods for type-safe navigation

extension NavigationExtensions on BuildContext {
  // Navigate to products list
  void goToProducts() {
    go(AppRouter.products);
  }

  // Navigate to product details
  // Example: context.goToProductDetail(123, product);
  void goToProductDetail(int productId, {Product? product}) {
    go(
      '/products/$productId',
      extra: product, // Pass product object
    );
  }

  // Navigate to user profile
  // Example: context.goToProfile(456, user: user, tab: 'posts');
  void goToProfile(
    int userId, {
    User? user,
    String tab = 'info',
    String sort = 'recent',
  }) {
    go(
      '/profile/$userId?tab=$tab&sort=$sort',
      extra: user,
    );
  }

  // Push (add to stack instead of replace)
  void pushToProductDetail(int productId, {Product? product}) {
    push('/products/$productId', extra: product);
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================
/*

// 1. NAVIGATE TO PRODUCTS
context.go('/products');
// OR
context.goToProducts();

// 2. NAVIGATE TO PRODUCT DETAIL
context.go('/products/123');
// OR type-safe with object:
context.goToProductDetail(123, product: myProduct);

// 3. NAVIGATE TO PROFILE WITH QUERY PARAMS
context.go('/profile/456?tab=posts&sort=recent');
// OR type-safe:
context.goToProfile(456, user: myUser, tab: 'posts', sort: 'recent');

// 4. PUSH (add to navigation stack)
context.push('/products/123');
context.pushToProductDetail(123, product: myProduct);

// 5. POP (go back)
context.pop();

// 6. CAN POP CHECK
if (context.canPop()) {
  context.pop();
} else {
  // Can't go back (at root)
}

// 7. NAMED ROUTES
context.goNamed('products');
context.goNamed('product-detail', pathParameters: {'id': '123'});

// 8. REPLACE (clear stack and navigate)
context.go('/products'); // Replaces current route

*/
