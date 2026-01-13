import 'package:flutter/material.dart';

// ================================================================================
// ==-= Flutter - Home work Lesson 19 =-=
// ================================================================================
// 1) Create assets/images folder in the project and add several images (.png or .jpg files) to it.
// 2) Write the added files in pubspec.yaml (flutter: assets section) and run flutter pub get.
// 3) Display a local image in the application using: Image.asset('assets/images/filename.png').
// 4) Display an image from the internet using: Image.network('URL_picture') (replace with actual link).
// 5) Add an icon to the screen, e.g., Icon(Icons.image), and adjust its size and color if necessary.
// 6) Create a gallery: use GridView.count with crossAxisCount: 2 to display a grid of images. Fill an array with data (list of local file paths or URLs) and pass them to GridView.
// 7) Use Image widget for each item in GridView. Set Image property fit: BoxFit.cover and wrap it in a container with fixed height so the image fills the cell evenly.
// 8) Run the application: make sure local pictures are displayed (if not - check the path and pubspec.yaml), network images are loaded, the icon is visible, and the gallery scrolls and displays all images correctly.

// ================================================================================
// Task 1, 2: Image paths and network URLs
// ================================================================================

// Task 1, 2: Local image paths (add your images to assets/images folder)
// To add your own images: place .png or .jpg files in assets/images/ folder
const List<String> localImages = [
  'assets/images/IMG_3307.JPG',
  'assets/images/T-Lab model 14 little men cleaning.png',
  'assets/images/T-Lab model 09.png',
  'assets/images/T-Lab model 04 order cleaning.png',
];

// Task 4: Network image URLs (for demo/fallback)
const List<String> networkImages = [
  'https://picsum.photos/400/400?random=1',
  'https://picsum.photos/400/400?random=2',
  'https://picsum.photos/400/400?random=3',
  'https://picsum.photos/400/400?random=4',
];

// ================================================================================
// Task 3, 4, 5, 6, 7: Image Gallery Screen
// ================================================================================

class ImageGalleryApp extends StatelessWidget {
  const ImageGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Image Gallery'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task 5: Display icon at the top
              Row(
                children: [
                  Icon(
                    Icons.image,
                    size: 32,
                    color: const Color.fromARGB(255, 38, 64, 84),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Image Gallery Demo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Section 1: Local Images
              const Text(
                'Local Images',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'To use these images: Copy the image files to assets/images/ folder in your project',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              // Task 6, 7: Local Images Gallery using GridView.count
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(localImages.length, (index) {
                  return _buildImageCard(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // Task 3: Display local image with Image.asset or network image
                      child: localImages[index].startsWith('assets')
                          ? Image.asset(
                              localImages[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildErrorWidget('Image not found');
                              },
                            )
                          : Image.network(
                              localImages[index],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return _buildErrorWidget('Load failed');
                              },
                            ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Section 2: Network Images
              const Text(
                'Network Images',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Task 6, 7: Network Images Gallery using GridView.count
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(networkImages.length, (index) {
                  return _buildImageCard(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // Task 4: Display network image with Image.network
                      child: Image.network(
                        networkImages[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Load failed',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Section 3: Icon Examples
              const Text(
                'Icon Examples',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 40,
                          color: const Color.fromARGB(255, 38, 64, 84),
                        ),
                        const SizedBox(height: 8),
                        const Text('Image'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.photo_library,
                          size: 40,
                          color: const Color.fromARGB(255, 40, 80, 112),
                        ),
                        const SizedBox(height: 8),
                        const Text('Gallery'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.photo,
                          size: 40,
                          color: const Color.fromARGB(255, 60, 100, 130),
                        ),
                        const SizedBox(height: 8),
                        const Text('Photo'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build error placeholder
  Widget _buildErrorWidget(String message) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Task 7: Helper widget to build image card with fixed height
  Widget _buildImageCard({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        // Task 7: Fixed height container so images fill cells evenly
        constraints: const BoxConstraints(minHeight: 200),
        child: child,
      ),
    );
  }
}

// ================================================================================
// Task 8: Result - Test image loading and gallery display
// ================================================================================
