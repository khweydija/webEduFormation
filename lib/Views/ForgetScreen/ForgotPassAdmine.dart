import 'package:flutter/material.dart';
import 'package:webpfe/Views/LoginScreen/LoginAdmin.dart';

class ForgotPassAdmine extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginAdmin()),
            );
          },
        ),
      ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        Text(
                          'Forgot your password?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Don\'t worry, happens to all of us. Enter your email below to recover your password',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Perform forgot password logic
                            }
                          },
                          child: Text('Submit',style: TextStyle(color: Colors.black),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 205, 206, 205),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                                 elevation: 5,
                                          shadowColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: Image.asset(
                      'assets/images/d2.jpeg', // Replace with your image asset
                      height: 400,
                      width: 400,
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
