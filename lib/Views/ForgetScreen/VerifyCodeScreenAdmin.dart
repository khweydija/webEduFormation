import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/controllers/auth_controller.dart';
import 'package:webpfe/AppRoutes.dart';

class VerifyCodeScreenAdmin extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        Text(
                          'Vérifiez le code',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Un code d\'authentification a été envoyé à votre adresse e-mail.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: codeController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Code',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer le code';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              print('Renvoi du code déclenché');
                            },
                            child: Text(
                                'Vous n\'avez pas reçu de code ? Renvoyer.'),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                String email = emailController.text.trim();
                                String code = codeController.text.trim();
                                await authController.verifyResetCode(
                                    email, code);
                              
                              }
                            },
                            child: Text(
                              'Vérifier.',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 225, 226, 225),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
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
                          'assets/images/d1.jpeg',
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
