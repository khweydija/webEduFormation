import 'package:flutter/material.dart';




class  VerifyCodeScreenAdmin extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 240, 239, 239),
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              // Navigate back to login screen
                            },
                            icon: Icon(Icons.arrow_back),
                            label: Text('Back to login'),
                          ),
                        ),
                        SizedBox(height: 50),
                        Text(
                          'Verify code',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'An authentication code has been sent to your email.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: codeController,
                            decoration: InputDecoration(
                              labelText: 'Enter Code',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the code';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              // Resend code logic
                            },
                            child: Text('Didn\'t receive a code? Resend'),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // Perform verify code logic
                              }
                            },
                            child: Text('Verify'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 65, 153, 141),
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/verify_code.png', // Replace with your image asset
                          height: 400,
                          width: 400,
                        ),
                      ],
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

  