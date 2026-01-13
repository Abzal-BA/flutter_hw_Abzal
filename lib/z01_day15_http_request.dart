import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ============================================================================
// -== Flutter - Home work Lesson 15 ==-
// ============================================================================
// 1) Add http dependency in pubspec.yaml and import package:http/http.dart package in your Dart file.
// 2) Create a data model for received objects. For example, Post class with fields corresponding to JSON (for example, int id, String title).
// 3) Write an asynchronous function fetchPosts() that performs a GET request to the API (for example, https://jsonplaceholder.typicode.com/posts).
// 4) Execute request inside fetchPosts(): call http.get, then decode the response via jsonDecode. Convert the received JSON array into a list of Post objects (for example, using Post.fromJson constructor).
// 5) Create StatefulWidget (for example, PostsPage) and call fetchPosts() in initState method. Save the result in state (posts list).
// 6) Display loading indicator (CircularProgressIndicator) while data is loading. After receiving data, show ListView.builder with list of posts.
// 7) Output each post in ListView.builder, for example using ListTile(title: Text(post.title)) to display the title.
// 8) Handle possible network errors: wrap http.get call in try/catch and in case of exception show error message instead of list (for example, Text("Loading error")).

// ============================================================================
// Task 2: Create data model for Post
// ============================================================================
class Post {
  final int id;
  final String title;
  final String? url;
  final int score;
  final String by;
  final int time;

  Post({
    required this.id,
    required this.title,
    this.url,
    required this.score,
    required this.by,
    required this.time,
  });

  // Factory constructor to create Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No title',
      url: json['url'] as String?,
      score: json['score'] as int? ?? 0,
      by: json['by'] as String? ?? 'Unknown',
      time: json['time'] as int? ?? 0,
    );
  }

  // Convert Unix timestamp to readable date
  String getFormattedDate() {
    final date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// ============================================================================
// Task 3, 4: Asynchronous function to fetch posts from API
// ============================================================================
Future<List<Post>> fetchPosts() async {
  // First, get the list of top story IDs
  final topStoriesUrl = Uri.parse(
    'https://hacker-news.firebaseio.com/v0/topstories.json',
  );

  // Task 8: Wrap in try/catch for error handling
  try {
    // Get top story IDs
    final topStoriesResponse = await http.get(topStoriesUrl);

    if (topStoriesResponse.statusCode == 200) {
      final List<dynamic> storyIds = jsonDecode(topStoriesResponse.body);

      // Get first 30 stories (to avoid too many requests)
      final limitedIds = storyIds.take(30).toList();
      final List<Post> posts = [];

      // Fetch each story details
      for (var id in limitedIds) {
        try {
          final storyUrl = Uri.parse(
            'https://hacker-news.firebaseio.com/v0/item/$id.json',
          );
          final storyResponse = await http.get(storyUrl);

          if (storyResponse.statusCode == 200) {
            final storyData = jsonDecode(storyResponse.body);
            // Only add stories (not jobs, polls, etc.)
            if (storyData['type'] == 'story') {
              posts.add(Post.fromJson(storyData));
            }
          }
        } catch (e) {
          // print('Error fetching story $id: $e');
          continue;
        }
      }

      if (posts.isEmpty) {
        throw Exception('No stories found');
      }

      return posts;
    } else {
      throw Exception(
        'Failed to load posts. Status code: ${topStoriesResponse.statusCode}',
      );
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}

// ============================================================================
// Task 5: Create StatefulWidget (PostsPage)
// ============================================================================
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  // State variables
  List<Post> posts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Task 5: Call fetchPosts in initState
    loadPosts();
  }

  // Load posts and handle errors
  Future<void> loadPosts() async {
    try {
      final fetchedPosts = await fetchPosts();
      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 15 - HTTP Request'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Hacker News Top Stories',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  // ============================================================================
  // Task 6: Display loading indicator or content
  // Task 8: Show error message if error occurred
  // ============================================================================
  Widget _buildContent() {
    if (isLoading) {
      // Task 6: Show loading indicator
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading posts...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      // Task 8: Show error message
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Loading error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  loadPosts();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // ============================================================================
    // Task 6, 7: Show ListView.builder with posts
    // ============================================================================
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        // Task 7: Display each post using ListTile
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                '${post.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'by ${post.by} • ${post.getFormattedDate()}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (post.url != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      post.url!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: Colors.blue),
                    ),
                  ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Show full post details in a dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hacker News Story'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_upward,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${post.score} points',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Author: ${post.by}'),
                        const SizedBox(height: 4),
                        Text('Posted: ${post.getFormattedDate()}'),
                        const SizedBox(height: 4),
                        Text('Story ID: ${post.id}'),
                        if (post.url != null) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'URL:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          SelectableText(
                            post.url!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
