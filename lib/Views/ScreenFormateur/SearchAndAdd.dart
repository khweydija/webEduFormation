import 'dart:typed_data'; // Required for handling Uint8List
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:webpfe/controllers/FormateurController.dart';

class SearchAndAdd extends StatefulWidget {
  @override
  _SearchAndAddState createState() => _SearchAndAddState();
}

class _SearchAndAddState extends State<SearchAndAdd> {
  final FormateurController _formateurController =
      Get.put(FormateurController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _specialiteController = TextEditingController();
  final TextEditingController _departementController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Uint8List? _selectedPhotoBytes;
  String? _photoFilename;
  bool _isPasswordVisible = false;

  void _pickPhoto() async {
    final pickedFile =
        await ImagePickerWeb.getImageAsBytes(); // Get image as bytes

    if (pickedFile != null) {
      setState(() {
        _selectedPhotoBytes = pickedFile;
        _photoFilename = "formateur_photo.png"; // Assign a default filename
      });
      print(
          "Image selected successfully"); // Debugging: Check if the image is selected
    } else {
      print("No image selected"); // Debugging: Check if no image was selected
    }
  }

  void _submitFormateur() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedPhotoBytes == null) {
        Get.snackbar('Error', 'Please select a photo');
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }

      _formateurController
          .createFormateur(
        email: _emailController.text,
        password: _passwordController.text,
        nom: _nomController.text,
        departement: _departementController.text,
        specialite: _specialiteController.text,
        photoBytes: _selectedPhotoBytes!,
        photoFilename: _photoFilename!,
      )
          .then((_) {
        // Show success message
        Get.snackbar('Success', 'Formateur has been entered');

        // Clear the input fields
        _nomController.clear();
        _specialiteController.clear();
        _departementController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        setState(() {
          _selectedPhotoBytes = null; // Clear the selected photo
          _photoFilename = null;
        });
      });
    }
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
                      hintText: 'Search for anything...',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddFormateurDialog,
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Ajouter Formateur',
                      style: TextStyle(color: Colors.white)),
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
            width: MediaQuery.of(context).size.width * 0.7,
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
                          'Ajouter Formateur',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
                    _buildFormFields(constraints: context),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _submitFormateur,
                          child: Text('Ajouter ',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF228D6D),
                          ),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Annuler'),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 133, 131, 131),
                          ),
                        ),
                      ],
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

  Widget _buildFormFields({required BuildContext constraints}) {
    bool isWideScreen = MediaQuery.of(context).size.width > 600;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      isWideScreen
                          ? Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                      controller: _nomController,
                                      labelText: 'Nom*'),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                      controller: _specialiteController,
                                      labelText: 'Spécialité*'),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildTextField(
                                    controller: _nomController,
                                    labelText: 'Nom*'),
                                SizedBox(height: 10),
                                _buildTextField(
                                    controller: _specialiteController,
                                    labelText: 'Spécialité*'),
                              ],
                            ),
                      SizedBox(height: 10),
                      isWideScreen
                          ? Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                      controller: _departementController,
                                      labelText: 'Departement*'),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildEmailField(
                                      controller: _emailController,
                                      labelText: 'Email*'),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildTextField(
                                    controller: _departementController,
                                    labelText: 'Departement*'),
                                SizedBox(height: 10),
                                _buildEmailField(
                                    controller: _emailController,
                                    labelText: 'Email*'),
                              ],
                            ),
                      SizedBox(height: 10),
                      isWideScreen
                          ? Row(
                              children: [
                                Expanded(
                                  child: _buildPasswordField(
                                      controller: _passwordController,
                                      labelText: 'Password*'),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildPasswordField(
                                      controller: _confirmPasswordController,
                                      labelText: 'Confirm Password*'),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildPasswordField(
                                    controller: _passwordController,
                                    labelText: 'Password*'),
                                SizedBox(height: 10),
                                _buildPasswordField(
                                    controller: _confirmPasswordController,
                                    labelText: 'Confirm Password*'),
                              ],
                            ),
                    ],
                  ),
                ),
                SizedBox(
                    width: 20), // Space between form fields and image picker
                _buildImagePicker(), // Image picker on the right
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String labelText}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(
      {required TextEditingController controller, required String labelText}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
      {required TextEditingController controller, required String labelText}) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible, // Add the obscureText condition
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickPhoto,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2, // Adjust the width
        height: 160, // Set height for the image picker container
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
          child: _selectedPhotoBytes == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt,
                        color: Colors.grey.shade600, size: 40),
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
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(
                    _selectedPhotoBytes!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}
