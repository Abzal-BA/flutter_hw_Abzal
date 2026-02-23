// ============================================================================
// Profile Screen
// ============================================================================
// Demonstrates go_router with path and query parameters
// Shows user profile with tabs
// ============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final User? user;
  final String initialTab;
  final String sortOrder;

  const ProfileScreen({
    super.key,
    required this.userId,
    this.user,
    this.initialTab = 'info',
    this.sortOrder = 'recent',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    
    // Initialize tab based on query parameter
    final initialIndex = widget.initialTab == 'posts' ? 1 : 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use provided user or create mock
    final user = widget.user ?? _getMockUser(widget.userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'Info', icon: Icon(Icons.person)),
            Tab(text: 'Posts', icon: Icon(Icons.article)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _InfoTab(user: user),
          _PostsTab(userId: widget.userId, sortOrder: widget.sortOrder),
        ],
      ),
    );
  }

  User _getMockUser(int userId) {
    return User(
      id: userId,
      name: 'User #$userId',
      email: 'user$userId@example.com',
      avatar: 'https://i.pravatar.cc/150?img=$userId',
      role: UserRole.user,
      address: Address(
        street: '123 Main St',
        city: 'San Francisco',
        country: 'USA',
        zipCode: '94102',
      ),
      registeredAt: DateTime.now().subtract(Duration(days: userId * 10)),
    );
  }
}

// ============================================================================
// Info Tab - Shows user information
// ============================================================================

class _InfoTab extends StatelessWidget {
  final User user;

  const _InfoTab({required this.user});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(user.avatar),
            onBackgroundImageError: (_, __) {},
            child: user.avatar.isEmpty
                ? Text(
                    user.name[0],
                    style: const TextStyle(fontSize: 48),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Role badge
          Chip(
            label: Text(user.role.name.toUpperCase()),
            backgroundColor: Colors.teal.withOpacity(0.1),
            labelStyle: TextStyle(
              color: Colors.teal[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Address card
          if (user.address != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(user.address!.street),
                    Text('${user.address!.city}, ${user.address!.zipCode}'),
                    Text(user.address!.country),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Registration date
          if (user.registeredAt != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.teal),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Member since',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          dateFormatter.format(user.registeredAt!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// Posts Tab - Demonstrates query parameters
// ============================================================================

class _PostsTab extends StatelessWidget {
  final int userId;
  final String sortOrder;

  const _PostsTab({
    required this.userId,
    required this.sortOrder,
  });

  @override
  Widget build(BuildContext context) {
    final posts = _getMockPosts(userId);
    
    // Sort based on query parameter
    if (sortOrder == 'oldest') {
      posts.sort((a, b) => a.id.compareTo(b.id));
    } else {
      posts.sort((a, b) => b.id.compareTo(a.id));
    }

    return Column(
      children: [
        // Sort indicator
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.teal.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.sort, size: 20),
              const SizedBox(width: 8),
              Text(
                'Sorted by: ${sortOrder == "oldest" ? "Oldest" : "Recent"}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Toggle sort order via query parameter
                  final newSort = sortOrder == 'recent' ? 'oldest' : 'recent';
                  context.go(
                    '/profile/$userId?tab=posts&sort=$newSort',
                  );
                },
                child: const Text('Toggle Sort'),
              ),
            ],
          ),
        ),
        
        // Posts list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#${post.id}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${post.id * 123} views',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.body,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Post> _getMockPosts(int userId) {
    return List.generate(
      8,
      (index) => Post(
        id: index + 1,
        userId: userId,
        title: 'Post #${index + 1} by User #$userId',
        body: 'This is the content of post #${index + 1}. '
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      ),
    );
  }
}
