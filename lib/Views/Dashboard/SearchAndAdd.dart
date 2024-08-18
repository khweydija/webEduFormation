import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:webpfe/controllers/FormateurController/CreateForController.dart';

class SearchAndAdd extends StatefulWidget {
  @override
  _SearchAndAddState createState() => _SearchAndAddState();
}

class _SearchAndAddState extends State<SearchAndAdd> {
  final CreateForController _createForController = Get.put(CreateForController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _specialiteController = TextEditingController();
  final TextEditingController _departementController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  html.File? _selectedPhoto;
  String? _photoUrl;
  bool _isPasswordVisible = false;

  // Pick a photo using ImagePickerWeb
  void _pickPhoto() async {
    final pickedFile = await ImagePickerWeb.getImageAsFile();

    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = pickedFile;
        _photoUrl = html.Url.createObjectUrl(_selectedPhoto!); // Generate preview URL
      });
    }
  }

  // Submit the formateur creation form
  void _submitFormateur() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedPhoto == null) {
        Get.snackbar('Error', 'Please select a photo');
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }

      try {
        print("Submitting form with photo and data...");

        // Send form data and photo to the controller
        await _createForController.createFormateur(
          email: _emailController.text,
          password: _passwordController.text,
          nom: _nomController.text,
          departement: _departementController.text,
          specialite: _specialiteController.text,
          photo: _selectedPhoto!, // Send the photo here
        );

        // Close the dialog on success
        Navigator.of(context).pop();
        Get.snackbar('Success', 'Formateur created successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to create formateur');
      }
    }
  }

  // Show the Add Formateur Dialog
  void _showAddFormateurDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Formateur',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWideScreen = constraints.maxWidth > 600;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isWideScreen
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _nomController,
                                          decoration: InputDecoration(
                                            labelText: 'Nom*',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter the name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _specialiteController,
                                          decoration: InputDecoration(
                                            labelText: 'Spécialité*',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter the specialty';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      TextFormField(
                                        controller: _nomController,
                                        decoration: InputDecoration(
                                          labelText: 'Nom*',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter the name';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        controller: _specialiteController,
                                        decoration: InputDecoration(
                                          labelText: 'Spécialité*',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter the specialty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                            SizedBox(height: 10),
                            isWideScreen
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _departementController,
                                          decoration: InputDecoration(
                                            labelText: 'Departement*',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter the department';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            labelText: 'Email*',
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
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      TextFormField(
                                        controller: _departementController,
                                        decoration: InputDecoration(
                                          labelText: 'Departement*',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter the department';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email*',
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
                                    ],
                                  ),
                            SizedBox(height: 10),
                            isWideScreen
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            labelText: 'Password*',
                                            border: OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isPasswordVisible = !_isPasswordVisible;
                                                });
                                              },
                                            ),
                                          ),
                                          obscureText: !_isPasswordVisible,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a password';
                                            } else if (value.length < 6) {
                                              return 'Password must be at least 6 characters long';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _confirmPasswordController,
                                          decoration: InputDecoration(
                                            labelText: 'Confirm Password*',
                                            border: OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isPasswordVisible = !_isPasswordVisible;
                                                });
                                              },
                                            ),
                                          ),
                                          obscureText: !_isPasswordVisible,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please confirm your password';
                                            }
                                            if (value != _passwordController.text) {
                                              return 'Passwords do not match';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      TextFormField(
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                          labelText: 'Password*',
                                          border: OutlineInputBorder(),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible = !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                        obscureText: !_isPasswordVisible,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a password';
                                          } else if (value.length < 6) {
                                            return 'Password must be at least 6 characters long';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        controller: _confirmPasswordController,
                                        decoration: InputDecoration(
                                          labelText: 'Confirm Password*',
                                          border: OutlineInputBorder(),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible = !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                        obscureText: !_isPasswordVisible,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your password';
                                          }
                                          if (value != _passwordController.text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                            SizedBox(height: 10),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: _pickPhoto,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _photoUrl == null
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt, color: Colors.grey.shade600, size: 40),
                                            SizedBox(height: 10),
                                            Text(
                                              'Tap to select photo',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Image.network(
                                          _photoUrl!,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: _submitFormateur,
                                  child: Text('Add User', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF228D6D),
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: constraints.maxWidth > 800
                      ? 700
                      : constraints.maxWidth * 0.7, // Dynamically adjust width
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search, color: Colors.black54),
                      hintText: 'Search for anything...',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddFormateurDialog,
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Add', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF228D6D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            // Additional content goes here
          ],
        );
      },
    );
  }
}
