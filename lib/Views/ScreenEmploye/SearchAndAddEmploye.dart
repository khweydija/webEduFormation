import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:webpfe/controllers/EmployeController.dart';

class SearchAndAddEmploye extends StatefulWidget {
  @override
  _SearchAndAddEmployeState createState() => _SearchAndAddEmployeState();
}

class _SearchAndAddEmployeState extends State<SearchAndAddEmploye> {
  final _formKey = GlobalKey<FormState>();
  final EmployeController _employeController = Get.put(EmployeController()); // Put controller

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _departementController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  html.File? _selectedPhoto;
  html.File? _selectedDiplome;
  String? _photoUrl;
  String? _diplomeUrl;
  bool _isPasswordVisible = false;

  // Picking a photo (image)
  void _pickPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _selectedPhoto = html.File([file.bytes!], file.name);
        _photoUrl = html.Url.createObjectUrl(_selectedPhoto!);
      });
    }
  }

  // Picking a diplome (PDF)
  void _pickDiplome() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _selectedDiplome = html.File([file.bytes!], file.name);
        _diplomeUrl = html.Url.createObjectUrl(_selectedDiplome!);
      });
    }
  }

  // Convert html.File to Uint8List
  Future<Uint8List> _convertFileToUint8List(html.File file) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file); // Read the file
    await reader.onLoadEnd.first; // Wait for the file to finish loading
    return reader.result as Uint8List;
  }

  // Submitting the employee form
  void _submitEmploye() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedPhoto == null) {
        Get.snackbar('Error', 'Please select a photo');
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }

      // Convert the selected files to Uint8List for sending with the request
      Uint8List photoBytes = await _convertFileToUint8List(_selectedPhoto!);
      Uint8List diplomeBytes = await _convertFileToUint8List(_selectedDiplome!);

      // Call the createEmploye method from the controller
      var response = await _employeController.createEmploye(
        email: _emailController.text,
        password: _passwordController.text,
        nom: _nomController.text,
        departement: _departementController.text,
        photoBytes: photoBytes,
        photoFilename: _selectedPhoto!.name,
        diplomeBytes: diplomeBytes,
        diplomeFilename: _selectedDiplome!.name,
      );

      if (response?.statusCode == 200) {
        Get.snackbar('Success', 'Employee created successfully');
        _clearFormFields(); // Clear the fields after success

        // Fetch all employees again to update the list in the UI
        _employeController.fetchAllEmployes();
      } else {
        Get.snackbar('Error', 'Failed to create employee');
      }
    }
  }

  void _clearFormFields() {
    _nomController.clear();
    _departementController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _photoUrl = null;
      _diplomeUrl = null;
      _selectedPhoto = null;
      _selectedDiplome = null;
    });
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
                      : constraints.maxWidth * 0.7, // Adjust width dynamically
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search, color: Colors.black54),
                      hintText: 'Search for employees...',
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
                  onPressed: _showAddEmployeDialog, // Add employee dialog
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Add Employee', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF228D6D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showAddEmployeDialog() {
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
                          'Add Employee',
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
                            // Name and Department
                            Row(
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
                              ],
                            ),
                            SizedBox(height: 10),

                            // Email Field
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
                            SizedBox(height: 10),

                            // Password and Confirm Password
                            Row(
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
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Photo and Diplome fields
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
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
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _pickDiplome,
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
                                        child: _diplomeUrl == null
                                            ? Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.file_present, color: Colors.grey.shade600, size: 40),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Tap to select a diplome (PDF)',
                                                    style: TextStyle(
                                                      color: Colors.grey.shade600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  Icon(Icons.file_present, size: 50),
                                                  Text(_selectedDiplome!.name),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),

                            // Add Employee Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: _submitEmploye,
                                  child: Text('Add Employee', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF228D6D),
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton(
                                  onPressed: _clearFormFields,
                                  child: Text('Clear'),
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
}
