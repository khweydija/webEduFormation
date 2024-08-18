import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/Views/LoginScreen/LoginAdmin.dart';
import 'package:webpfe/controllers/auth_controller.dart';

class SignUpScreenAdmin extends StatefulWidget {
  @override
  _SignUpScreenAdminState createState() => _SignUpScreenAdminState();
}

class _SignUpScreenAdminState extends State<SignUpScreenAdmin> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = Get.put(AuthController());

  bool _obscureText = true;
  bool _confirmObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/d1.jpeg', // Replace with your image asset
                          height: 700,
                          width: 400,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Let\'s get you all set up so you can access your personal account:',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Nom',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmObscureText ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmObscureText = !_confirmObscureText;
                                  });
                                },
                              ),
                            ),
                            obscureText: _confirmObscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 20),
                          Center(
                            child: Obx(() {
                              return ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    _authController.signup(
                                      emailController.text,
                                      passwordController.text,
                                      lastNameController.text,
                                    );
                                  }
                                },
                                child: _authController.isLoading.value
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                        'Create account',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 205, 206, 205),
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                  elevation: 5, // Add shadow to the button
                                  shadowColor: Colors.black,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginAdmin()));
                              },
                              child: Text('Already have an account? Login'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
