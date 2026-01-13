import 'package:flutter/material.dart';

// ============================================================================
// -== Flutter - Home work Lesson 12 ==-
// ============================================================================
// 1) Create StatefulWidget LoginPage (data input screen).
// 2) Declare variables in the state class: GlobalKey<FormState> formKey = GlobalKey<FormState>() and two TextEditingController (for email field and password field).
// 3) In the build method return Scaffold, inside it place Form with formKey key.
// 4) Add TextFormField widget inside Form for email. Bind the created emailController to it and set the validator property (for example, check that the entered text contains "@" and is not empty).
// 5) Add second TextFormField for password. Bind passwordController to it and set validator (for example, require minimum 6 characters).
// 6) Add ElevatedButton button with text "Login". In its onPressed call formKey.currentState!.validate() to start checking all validators in the form.
// 7) Display successful login message (for example, via print or SnackBar) and clear input fields if formKey.currentState!.validate() returned true (i.e. all data is filled correctly).
// 8) Run the application and test the form: with empty or incorrect data validation errors should be displayed, and with correct input - a success message will appear and fields will be cleared.

// ============================================================================
// Task 1: Create StatefulWidget LoginPage
// ============================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// ============================================================================
// Task 2: Declare variables (formKey and TextEditingControllers)
// ============================================================================
class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================================
  // Task 3: Build method returns Scaffold with Form
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 12 - Login Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // ============================================================================
                // Task 4: TextFormField for email with validator
                // ============================================================================
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email with @';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // ============================================================================
                // Task 5: TextFormField for password with validator
                // ============================================================================
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                
                // ============================================================================
                // Task 6: ElevatedButton with validation
                // Task 7: Show success message and clear fields
                // ============================================================================
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Show success message via SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login successful!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      
                      // Print to console
                      // print('Login successful!');
                      // print('Email: ${emailController.text}');
                      
                      // Clear input fields
                      emailController.clear();
                      passwordController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
