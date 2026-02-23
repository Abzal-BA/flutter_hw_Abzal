// ============================================================================
// Products Screen - Demonstrates cached_network_image
// ============================================================================
// Shows a list of products with network images
// Uses cached_network_image for efficient image loading
//
// 🎯 FEATURES:
// ✅ Automatic image caching (disk + memory)
// ✅ Placeholder while loading
// ✅ Error widget for failed loads
// ✅ Fade-in animation
// ✅ Progress indicator
// ✅ Memory efficient
// ============================================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../models.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Back to Day 31 Demo home
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockProducts.length,
        itemBuilder: (context, index) {
          final product = _mockProducts[index];
          return _ProductCard(product: product);
        },
      ),
    );
  }
}

// ============================================================================
// Product Card Widget
// ============================================================================
// Demonstrates cached_network_image with all features

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // Format price with intl
    // ============================================================
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final priceText = formatter.format(product.price);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: InkWell(
        onTap: () {
          // ============================================
          // Navigate to product detail with go_router
          // ============================================
          // Pass product object via extra parameter
          context.go('/products/${product.id}', extra: product);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================
            // CACHED NETWORK IMAGE
            // ============================================
            // Demonstrates all key features
            CachedNetworkImage(
              imageUrl: product.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              
              // ============================================
              // PLACEHOLDER: Shown while loading
              // ============================================
              // Shows shimmer effect or progress indicator
              placeholder: (context, url) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              
              // ============================================
              // ERROR WIDGET: Shown when image fails
              // ============================================
              // Shows icon when network error or invalid URL
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey[300],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              
              // ============================================
              // ANIMATION: Fade in when loaded
              // ============================================
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 100),
            ),
            
            // Product info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Price and stock
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        priceText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (product.stock != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: product.stock! > 0
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.stock! > 0
                                ? '${product.stock} in stock'
                                : 'Out of stock',
                            style: TextStyle(
                              fontSize: 12,
                              color: product.stock! > 0
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// MOCK DATA
// ============================================================================
// Using real image URLs from public APIs

final List<Product> _mockProducts = [
  Product(
    id: 1,
    title: 'Wireless Headphones',
    price: 99.99,
    description: 'Premium noise-canceling wireless headphones with 30-hour battery life',
    category: 'Electronics',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
    stock: 15,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Product(
    id: 2,
    title: 'Smart Watch',
    price: 299.99,
    description: 'Fitness tracking, heart rate monitor, GPS, water resistant',
    category: 'Wearables',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
    stock: 8,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Product(
    id: 3,
    title: 'Laptop Backpack',
    price: 49.99,
    description: 'Durable backpack with padded laptop compartment and USB charging port',
    category: 'Accessories',
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
    stock: 25,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Product(
    id: 4,
    title: 'Mechanical Keyboard',
    price: 129.99,
    description: 'RGB backlit mechanical keyboard with cherry MX switches',
    category: 'Electronics',
    imageUrl: 'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?w=500',
    stock: 12,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Product(
    id: 5,
    title: 'Wireless Mouse',
    price: 39.99,
    description: 'Ergonomic wireless mouse with 6 programmable buttons',
    category: 'Electronics',
    imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500',
    stock: 30,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Product(
    id: 6,
    title: 'USB-C Hub',
    price: 59.99,
    description: '7-in-1 USB-C hub with HDMI, USB 3.0, SD card reader',
    category: 'Accessories',
    imageUrl: 'https://images.unsplash.com/photo-1625948515291-69613efd103f?w=500',
    stock: 0,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),
];
