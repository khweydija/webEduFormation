import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/AppRoutes.dart';
import 'package:webpfe/Views/ForgetScreen/ForgotPassAdmine.dart';
import 'package:webpfe/controllers/auth_controller.dart';

class LoginAdmin extends StatefulWidget {
  @override
  _LoginAdminState createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Connectez-vous pour accéder à votre compte administrateur',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Veuillez entrer votre email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Veuillez entrer un email valide';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    labelText: 'Mot de passe',
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Veuillez entrer votre mot de passe';
                                    }
                                    if (value.length < 6) {
                                      return 'Le mot de passe doit comporter au moins 6 caractères';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.offAllNamed(AppRoutes.forgotPassAdmine);
                                      },
                                      child: Text('Mot de passe oublié'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Obx(() => authController.isLoading.value
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,

                                          strokeWidth: 2,
                                          // strokeAlign: StrokeAlign.outside,
                                        ),
                                      )
                                    : ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            authController.login(
                                              _emailController.text,
                                              _passwordController.text,
                                            );
                                          }
                                        },
                                        child: Text(
                                          'Connexion',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 205, 206, 205),
                                          minimumSize:
                                              Size(double.infinity, 50),
                                          elevation: 5,
                                          shadowColor: Colors.black,
                                        ),
                                      )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Image.asset(
                            'assets/images/dd.jpeg',
                            width: 200,
                            height: 500,
                          ), // Replace with your image path
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
