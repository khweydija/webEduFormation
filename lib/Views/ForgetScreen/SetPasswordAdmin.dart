import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webpfe/AppRoutes.dart';

class SetPasswordAdmin extends StatefulWidget {
  final String email;
  final String code;

  SetPasswordAdmin({required this.email, required this.code});

  @override
  State<SetPasswordAdmin> createState() => _SetPasswordAdminState();
}

class _SetPasswordAdminState extends State<SetPasswordAdmin> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  bool _isObscuredConfirm = true;

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final String baseUrl = 'http://localhost:8080/auth';

  bool _isObscured = true;

  Future<void> resetPassword(
      String email, String code, String newPassword) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/reset-password'),
      );
      request.fields['email'] = email;
      request.fields['code'] = code;
      request.fields['newPassword'] = newPassword;

      final response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 200) {
        // Get.toNamed(AppRoutes.loginAdmin);
        print('Password reset successfully for $email');
      } else {
        throw Exception('Failed to reset password: ${response.statusCode}');
      }
    } catch (e) {
      print("Error resetting password: $e");
      return Future.error('Failed to reset password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Définir un mot de passe',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Votre mot de passe précédent a été réinitialisé \n Veuillez définir un nouveau mot de passe pour votre compte.',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Créer un mot de passe',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscured
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                            ),
                          ),
                          obscureText: _isObscured,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un nouveau mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit comporter au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirmer le mot de passe',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscuredConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscuredConfirm = !_isObscuredConfirm;
                                });
                              },
                            ),
                          ),
                          obscureText: _isObscuredConfirm,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un nouveau mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit comporter au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final newPassword = _passwordController.text;
                              await resetPassword(
                                  widget.email, widget.code, newPassword);
                              Get.snackbar(
                                  'Success', 'Password reset successfully');
                              Get.toNamed(AppRoutes.loginAdmin);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                          ),
                          child: Text('Définir le mot de passe'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset(
                    'assets/images/d2.jpeg',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
