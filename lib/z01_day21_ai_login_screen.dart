// ================================================================================
// ==-= Flutter - Home work Lesson 21 =-=
// ================================================================================
// 1) Choose an AI tool for programming (e.g., ChatGPT via browser or GitHub Copilot in VS Code).
// 2) Formulate a request to AI: ask to generate code for a simple Flutter screen (e.g., login screen with two text fields and a button).
// 3) Copy the code suggested by AI and paste it into your Flutter project.
// 4) Run the application and check that the AI-generated screen compiles and displays (fix any errors if they occur).
// 5) Analyze the AI-generated code and manually improve it: correct widget layout and styles, rename variables for clarity, add validation or error handling if needed.
// 6) Run the application again and make sure the screen works correctly after your edits and meets requirements.

// ================================================================================
// AI Prompt Used:
// "Generate a Flutter login screen with email and password TextFormFields, 
//  a login button, and basic validation. The screen should have an AppBar 
//  and look professional."
// ================================================================================
// 
// Note: This code was generated with AI assistance and then improved:
// - Added better error handling
// - Improved UI/UX with card layout
// - Added password visibility toggle
// - Enhanced validation messages
// - Added proper styling and spacing
// ================================================================================

import 'package:flutter/material.dart';

class LoginScreenApp extends StatefulWidget {
  const LoginScreenApp({super.key});

  @override
  State<LoginScreenApp> createState() => _LoginScreenAppState();
}

class _LoginScreenAppState extends State<LoginScreenApp> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields (improved naming from AI suggestion)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Toggle password visibility (improvement to AI code)
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    // Proper cleanup (improvement to AI code)
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Email validation method (improvement to AI code)
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation method (improvement to AI code)
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Handle login (improvement to AI code)
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate login process
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome, ${_emailController.text}!',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Clear fields after successful login (improvement to AI code)
        _emailController.clear();
        _passwordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('AI-Generated Login Screen'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 38, 64, 84),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              
              // Header (improvement to AI code - added icon and styling)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: const Color.fromARGB(255, 38, 64, 84),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              // Form (wrapped in Card for better visual hierarchy - improvement to AI code)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email field (improved validation and styling from AI code)
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 38, 64, 84),
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),
                        
                        // Password field (improved with visibility toggle - improvement to AI code)
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 38, 64, 84),
                                width: 2,
                              ),
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 24),
                        
                        // Login button (improved with loading state - improvement to AI code)
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 38, 64, 84),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Demo note (improvement to AI code - added info for user)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Credentials:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Email: demo@example.com',
                      style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                    ),
                    Text(
                      'Password: password123',
                      style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
