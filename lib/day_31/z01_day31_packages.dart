// ============================================================================
// Flutter - Day 31 Lesson: Popular Packages Integration
// ============================================================================
// Comprehensive demonstration of essential Flutter packages:
//
// 1) freezed + json_serializable: Immutable models with JSON serialization
// 2) cached_network_image: Efficient image loading with caching
// 3) intl: Internationalization (date/currency formatting, locale switching)
// 4) go_router: Declarative routing with type-safe parameters
// 5) flutter_secure_storage: Secure token/credential storage
//
// 🎯 LEARNING OUTCOMES:
// ✅ Generate immutable models with freezed
// ✅ Handle JSON serialization automatically
// ✅ Load and cache network images efficiently
// ✅ Format dates and currencies for different locales
// ✅ Implement type-safe routing with parameters
// ✅ Store sensitive data securely
// ============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import 'models.dart';
import 'secure_storage.dart';

// ============================================================================
// Main App Entry Point
// ============================================================================

class Day31PackagesApp extends StatefulWidget {
  const Day31PackagesApp({super.key});

  @override
  State<Day31PackagesApp> createState() => _Day31PackagesAppState();
}

class _Day31PackagesAppState extends State<Day31PackagesApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentLocale = 'en';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    // Initialize date formatting for locales
    initializeDateFormatting();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _changeLocale(String locale) {
    setState(() {
      _currentLocale = locale;
      Intl.defaultLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Day 31 · Popular Packages'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 76, 40, 130),
        actions: [
          // Locale switcher
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: _changeLocale,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'en', child: Text('🇺🇸 English')),
              const PopupMenuItem(value: 'ru', child: Text('🇷🇺 Русский')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: '📦 Freezed'),
            Tab(text: '🖼️ Images'),
            Tab(text: '🌍 Intl'),
            Tab(text: '🗺️ Router'),
            Tab(text: '🔒 Storage'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FreezedTab(locale: _currentLocale),
          const _CachedImageTab(),
          _IntlTab(locale: _currentLocale),
          const _RouterTab(),
          const _SecureStorageTab(),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 1: Freezed + JSON Serialization Demo
// ============================================================================

class _FreezedTab extends StatelessWidget {
  final String locale;

  const _FreezedTab({required this.locale});

  @override
  Widget build(BuildContext context) {
    // Create product instance
    final product = Product(
      id: 1,
      title: 'Gaming Laptop',
      price: 1299.99,
      description: 'High-performance gaming laptop with RTX 4080',
      category: 'Electronics',
      imageUrl: 'https://example.com/laptop.jpg',
      stock: 5,
      createdAt: DateTime.now(),
    );

    // Serialize to JSON
    final json = product.toJson();
    final jsonString = const JsonEncoder.withIndent('  ').convert(json);

    // Demonstrate copyWith
    final discountedProduct = product.copyWith(
      price: 999.99,
      stock: 3,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Freezed + JSON Serializable',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '🎯 What is Freezed?',
            content: 'Code generator for immutable classes:\n'
                '• Auto-generates copyWith, ==, hashCode, toString\n'
                '• Union types (sealed classes)\n'
                '• JSON serialization with json_serializable\n'
                '• No manual boilerplate code',
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '📝 Original Product',
            content: 'ID: ${product.id}\n'
                'Title: ${product.title}\n'
                'Price: \$${product.price}\n'
                'Stock: ${product.stock}\n'
                'Category: ${product.category}',
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '✏️ copyWith() Demo',
            content: 'Updated with copyWith():\n'
                'Price: \$${discountedProduct.price} (was \$${product.price})\n'
                'Stock: ${discountedProduct.stock} (was ${product.stock})\n\n'
                'Other fields unchanged!',
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '🔄 JSON Serialization',
            content: 'toJson() output:\n$jsonString',
            color: Colors.purple,
          ),
          const SizedBox(height: 16),
          
          ElevatedButton.icon(
            onPressed: () {
              // Test equality
              final copy = Product.fromJson(product.toJson());
              final isEqual = product == copy;
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Equality test: ${isEqual ? "PASSED ✓" : "FAILED ✗"}\n'
                    'Original == FromJSON: $isEqual',
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Test Equality'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 2: Cached Network Image Demo
// ============================================================================

class _CachedImageTab extends StatelessWidget {
  const _CachedImageTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cached Network Image',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '🖼️ Features',
            content: '• Automatic image caching (memory + disk)\n'
                '• Placeholder while loading\n'
                '• Error widget for failed loads\n'
                '• Fade-in animations\n'
                '• Progress indicators\n'
                '• Memory efficient',
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Try the demo:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to products screen using go_router
                context.go('/products');
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('View Products with Images'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          const Text(
            'Code Example:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'CachedNetworkImage(\n'
              '  imageUrl: product.imageUrl,\n'
              '  placeholder: (context, url) =>\n'
              '    CircularProgressIndicator(),\n'
              '  errorWidget: (context, url, error) =>\n'
              '    Icon(Icons.error),\n'
              '  fadeInDuration: Duration(milliseconds: 300),\n'
              ')',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 3: Intl (Internationalization) Demo
// ============================================================================

class _IntlTab extends StatelessWidget {
  final String locale;

  const _IntlTab({required this.locale});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    
    // Date formatting
    final dateFormatter = DateFormat.yMMMMd(locale);
    final timeFormatter = DateFormat.jms(locale);
    final fullFormatter = DateFormat.yMMMMEEEEd(locale);
    
    // Currency formatting
    final usdFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2, locale: locale);
    final rubFormat = NumberFormat.currency(symbol: '₽', decimalDigits: 2, locale: locale);
    final eurFormat = NumberFormat.currency(symbol: '€', decimalDigits: 2, locale: locale);
    
    // Number formatting
    final numberFormat = NumberFormat.decimalPattern(locale);
    final percentFormat = NumberFormat.percentPattern(locale);

    final price = 1234.56;
    final bigNumber = 1234567.89;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Internationalization (intl)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '🌍 Current Locale',
            content: locale == 'en' ? '🇺🇸 English (US)' : '🇷🇺 Русский (Russian)',
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '📅 Date Formatting',
            content: 'Short: ${dateFormatter.format(now)}\n'
                'Time: ${timeFormatter.format(now)}\n'
                'Full: ${fullFormatter.format(now)}',
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '💰 Currency Formatting',
            content: 'USD: ${usdFormat.format(price)}\n'
                'RUB: ${rubFormat.format(price)}\n'
                'EUR: ${eurFormat.format(price)}',
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '🔢 Number Formatting',
            content: 'Number: ${numberFormat.format(bigNumber)}\n'
                'Percent: ${percentFormat.format(0.8542)}',
            color: Colors.purple,
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Switch language using the 🌍 icon in app bar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 4: Go Router Demo
// ============================================================================

class _RouterTab extends StatelessWidget {
  const _RouterTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Go Router Navigation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '🗺️ Features',
            content: '• Declarative routing\n'
                '• Type-safe parameters\n'
                '• Deep linking support\n'
                '• Nested navigation\n'
                '• Route guards\n'
                '• Browser back button (web)',
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Routes in this app:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          // Route 1: Products
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('1'),
              ),
              title: const Text('/products'),
              subtitle: const Text('Products list with images'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go('/products'),
            ),
          ),
          const SizedBox(height: 8),
          
          // Route 2: Product Detail
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('2'),
              ),
              title: const Text('/products/:id'),
              subtitle: const Text('Product detail (path parameter)'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                final product = Product(
                  id: 123,
                  title: 'Demo Product',
                  price: 99.99,
                  description: 'This is a demo',
                  category: 'Demo',
                  imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
                );
                context.go('/products/123', extra: product);
              },
            ),
          ),
          const SizedBox(height: 8),
          
          // Route 3: Profile
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Text('3'),
              ),
              title: const Text('/profile/:userId?tab=posts'),
              subtitle: const Text('User profile (path + query params)'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                final user = User(
                  id: 456,
                  name: 'Demo User',
                  email: 'demo@example.com',
                  avatar: 'https://i.pravatar.cc/150?img=5',
                );
                context.go('/profile/456?tab=posts&sort=recent', extra: user);
              },
            ),
          ),
          const SizedBox(height: 24),
          
          const Text(
            'Code Example:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '// Navigate with path parameter\n'
              'context.go(\'/products/123\');\n\n'
              '// With query parameters\n'
              'context.go(\'/profile/456?tab=posts\');\n\n'
              '// With extra data\n'
              'context.go(\n'
              '  \'/products/123\',\n'
              '  extra: productObject,\n'
              ');',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab 5: Secure Storage Demo
// ============================================================================

class _SecureStorageTab extends StatefulWidget {
  const _SecureStorageTab();

  @override
  State<_SecureStorageTab> createState() => _SecureStorageTabState();
}

class _SecureStorageTabState extends State<_SecureStorageTab> {
  final _storage = SecureStorageService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String? _storedToken;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkAuth() async {
    final isAuth = await _storage.isAuthenticated();
    final token = await _storage.getAuthToken();
    setState(() {
      _isAuthenticated = isAuth;
      _storedToken = token != null
          ? 'Token: ${token.accessToken.substring(0, 20)}...'
          : null;
    });
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Please enter email and password');
      return;
    }

    // Demo: Create and save token
    final token = AuthToken(
      accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.demo_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      tokenType: 'Bearer',
    );

    await _storage.saveAuthToken(token);
    await _storage.saveCredentials(
      email: _emailController.text,
      password: _passwordController.text,
    );

    _emailController.clear();
    _passwordController.clear();
    
    await _checkAuth();
    _showMessage('✅ Logged in! Token saved securely');
  }

  Future<void> _logout() async {
    await _storage.clearTokens();
    await _storage.clearCredentials();
    await _checkAuth();
    _showMessage('🔓 Logged out! Token cleared');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Flutter Secure Storage',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _InfoCard(
            title: '🔒 Security Features',
            content: '• iOS: Keychain\n'
                '• Android: KeyStore with AES\n'
                '• Encrypted storage\n'
                '• Perfect for tokens/credentials\n'
                '• NOT for large data',
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          
          // Auth status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isAuthenticated ? Colors.green.shade50 : Colors.red.shade50,
              border: Border.all(
                color: _isAuthenticated ? Colors.green : Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _isAuthenticated ? Icons.check_circle : Icons.cancel,
                  color: _isAuthenticated ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isAuthenticated ? 'Authenticated ✓' : 'Not Authenticated ✗',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isAuthenticated ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                      if (_storedToken != null)
                        Text(
                          _storedToken!,
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Login form
          if (!_isAuthenticated) ...[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _login,
                icon: const Icon(Icons.login),
                label: const Text('Login (Demo)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// Helper Widget
// ============================================================================

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
