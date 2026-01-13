import 'package:flutter/material.dart';

// ================================================================================
// ==-= Flutter - Home work Lesson 18 =-=
// ================================================================================
// 1) Define two app themes: lightTheme = ThemeData.light() and darkTheme = ThemeData.dark() (customize colors and fonts if desired).
// 2) Create the ability to switch themes: add a boolean field isDark = false in the main StatefulWidget (e.g., MyApp) to track the current theme.
// 3) Configure MaterialApp to use both themes: specify theme: lightTheme, darkTheme: darkTheme, and choose themeMode depending on isDark (isDark ? ThemeMode.dark : ThemeMode.light).
// 4) Add a theme switcher to the interface (e.g., Switch in AppBar or IconButton). In the change handler call setState(), switching the isDark value to the opposite.
// 5) Define screen width for adaptivity: final width = MediaQuery.of(context).size.width.
// 6) Change widget layout depending on screen width (or orientation). For example, if width > 600, use Row to arrange elements in two columns; otherwise, arrange elements in Column (one column).
// 7) Implement other adaptive UI improvements: with large width, increase padding, font sizes, or add additional panels.
// 8) Run the application on different devices (or emulate different screen sizes) and check: the switcher successfully changes light/dark theme, and the layout and style of elements change for large screens.

// ================================================================================
// Task 1: Define two app themes - light and dark
// ================================================================================

// Task 1: Light theme with custom colors
final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: const Color.fromARGB(255, 38, 64, 84),
  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 38, 64, 84),
    secondary: const Color.fromARGB(255, 40, 80, 112),
    surface: Colors.white,
    background: const Color(0xFFF5F5F5),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 38, 64, 84),
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
  ),
);

// Task 1: Dark theme with custom colors
final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: const Color.fromARGB(255, 60, 100, 130),
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 60, 100, 130),
    secondary: const Color.fromARGB(255, 80, 120, 150),
    surface: const Color(0xFF1E1E1E),
    background: const Color(0xFF121212),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 60, 100, 130),
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  cardTheme: CardThemeData(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
  ),
);

// ================================================================================
// Task 2, 3: Main App with Theme Switching
// ================================================================================

// Task 2: StatefulWidget with isDark field to track current theme
class ThemeAdaptiveApp extends StatefulWidget {
  const ThemeAdaptiveApp({super.key});

  @override
  State<ThemeAdaptiveApp> createState() => _ThemeAdaptiveAppState();
}

class _ThemeAdaptiveAppState extends State<ThemeAdaptiveApp> {
  // Task 2: Boolean field to track dark theme state
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    // Task 3: Use Theme.of(context) to inherit parent theme, apply dark mode if needed
    return Theme(
      data: isDark ? darkTheme : lightTheme,
      child: AdaptiveHomeScreen(
        isDark: isDark,
        onThemeChanged: (value) {
          // Task 4: setState to switch theme
          setState(() {
            isDark = value;
          });
        },
      ),
    );
  }
}

// ================================================================================
// Task 4, 5, 6, 7: Adaptive Home Screen with Theme Switcher
// ================================================================================

class AdaptiveHomeScreen extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const AdaptiveHomeScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Task 5: Define screen width for adaptivity
    final width = MediaQuery.of(context).size.width;
    
    // Task 6, 7: Determine if it's a large screen (tablet/desktop)
    final isLargeScreen = width > 600;
    final padding = isLargeScreen ? 32.0 : 16.0;
    final fontSize = isLargeScreen ? 18.0 : 14.0;
    final headingSize = isLargeScreen ? 28.0 : 22.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isLargeScreen ? 'Theme & Adaptive Layout - Large Screen' : 'Theme & Adaptive'),
        actions: [
          // Task 4: Theme switcher with IconButton in AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                Switch(
                  value: isDark,
                  onChanged: onThemeChanged,
                  activeColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Adaptive Layout Demo',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding),
            
            // Info Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                          size: isLargeScreen ? 32 : 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Current Theme: ${isDark ? "Dark" : "Light"}',
                          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: padding / 2),
                    Text(
                      'Screen Width: ${width.toInt()}px',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      'Layout Mode: ${isLargeScreen ? "Large Screen (2 columns)" : "Small Screen (1 column)"}',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: padding),
            
            Text(
              'Content Grid',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding / 2),
            
            // Task 6: Adaptive layout - Row for large screens, Column for small screens
            isLargeScreen
                ? _buildLargeScreenLayout(padding, fontSize)
                : _buildSmallScreenLayout(padding, fontSize),
          ],
        ),
      ),
      // Task 7: Add floating action button with adaptive positioning
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          onThemeChanged(!isDark);
        },
        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        label: Text(isDark ? 'Light Mode' : 'Dark Mode'),
      ),
    );
  }

  // Task 6: Large screen layout with Row (2 columns)
  Widget _buildLargeScreenLayout(double padding, double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildFeatureCard('Adaptive Layout', 'Responsive design that adjusts to screen size', Icons.devices, padding, fontSize),
              SizedBox(height: padding),
              _buildFeatureCard('Theme Switching', 'Toggle between light and dark themes', Icons.palette, padding, fontSize),
            ],
          ),
        ),
        SizedBox(width: padding),
        Expanded(
          child: Column(
            children: [
              _buildFeatureCard('Large Screen', 'Two column layout for tablets and desktops', Icons.tablet, padding, fontSize),
              SizedBox(height: padding),
              _buildFeatureCard('Small Screen', 'Single column layout for mobile devices', Icons.phone_android, padding, fontSize),
            ],
          ),
        ),
      ],
    );
  }

  // Task 6: Small screen layout with Column (1 column)
  Widget _buildSmallScreenLayout(double padding, double fontSize) {
    return Column(
      children: [
        _buildFeatureCard('Adaptive Layout', 'Responsive design that adjusts to screen size', Icons.devices, padding, fontSize),
        SizedBox(height: padding),
        _buildFeatureCard('Theme Switching', 'Toggle between light and dark themes', Icons.palette, padding, fontSize),
        SizedBox(height: padding),
        _buildFeatureCard('Large Screen', 'Two column layout for tablets and desktops', Icons.tablet, padding, fontSize),
        SizedBox(height: padding),
        _buildFeatureCard('Small Screen', 'Single column layout for mobile devices', Icons.phone_android, padding, fontSize),
      ],
    );
  }

  // Task 7: Feature card with adaptive styling
  Widget _buildFeatureCard(String title, String description, IconData icon, double padding, double fontSize) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: padding * 1.5),
                SizedBox(width: padding / 2),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize + 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: padding / 2),
            Text(
              description,
              style: TextStyle(fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================================
// Task 8: Result - Test on different devices and screen sizes
// ================================================================================
