import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:webpfe/controllers/DepartementController.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:webpfe/controllers/EmployeController.dart';
import 'package:webpfe/controllers/SpecialiteController.dart';

class SearchAndAddEmploye extends StatefulWidget {
  @override
  _SearchAndAddEmployeState createState() => _SearchAndAddEmployeState();
}

class _SearchAndAddEmployeState extends State<SearchAndAddEmploye> {
  final _formKey = GlobalKey<FormState>();
  final EmployeController _employeController = Get.put(EmployeController());

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _specialiteController;
  String? _departementController;

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  html.File? _selectedPhoto;
  html.File? _selectedDiplome;
  Uint8List? _photoBytes; // Store the selected image as Uint8List for preview
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
        _photoBytes = file.bytes; // Save the photo bytes for preview
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
        Get.snackbar('Error', 'Veuillez sélectionner une photo');
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        Get.snackbar('Error', 'Les mots de passe ne correspondent pas');
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
        prenom: _prenomController.text,
        specialite: _specialiteController!,
        photo: _selectedPhoto!,
        diplome: _selectedDiplome!,
      );

      if (response?.statusCode == 200) {
        Get.snackbar('Succès', 'Employé créé avec succès');
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
    _prenomController.clear();
    _specialiteController = null;
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _photoBytes = null;
      _selectedPhoto = null;
      _selectedDiplome = null;
    });
  }

  // // Search employee by query
  // void _searchEmployee() {
  //   String query = _searchController.text.trim();
  //   _employeController.searchEmploye(query);
  // }

  @override
  void initState() {
    super.initState();
    final SpecialiteController specialiteController =
        Get.put(SpecialiteController());
    specialiteController.fetchSpecialites();

    final DepartementController departementController =
        Get.put(DepartementController());
    departementController.fetchDepartements();
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Search Bar
                Container(
                  width: constraints.maxWidth > 800
                      ? 700
                      : constraints.maxWidth * 0.7, // Adjust width dynamically
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      // suffixIcon: IconButton(
                      //   icon: Icon(Icons.search, color: Colors.black54),
                      //   onPressed: _searchEmployee,
                      // ),
                      hintText: 'Rechercher des employés...',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 241, 240, 240),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    ),
                  ),
                ),
                // Add Employee Button
                ElevatedButton.icon(
                  onPressed:
                      _showAddEmployeDialog, // Show employee creation dialog
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Ajouter un employé',
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

  // Dialog for Adding Employee
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
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ajouter un employé',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _photoBytes = null;
                              _selectedPhoto = null;
                              _selectedDiplome = null;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Employee Form Fields
                    _buildEmployeeFormFields(),
                    SizedBox(height: 20),
                    // Add Employee Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _submitEmploye,
                          child: Text('Ajouter un employé',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF228D6D),
                          ),
                        ),
                        SizedBox(width: 10),
                        // TextButton(
                        //   onPressed: _clearFormFields,
                        //   child: Text('Clear'),
                        //   style: TextButton.styleFrom(
                        //     foregroundColor: Colors.grey,
                        //   ),
                        // ),
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

  // Employee Form Fields Widget
  Widget _buildEmployeeFormFields() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        return 'Veuillez entrer le nom';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _prenomController,
                    decoration: InputDecoration(
                      labelText: 'Prénom*',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nom';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildDepartementDropdown(), // Department Dropdown
            SizedBox(height: 10),
            _buildSpecialiteDropdown(), // Specialty Dropdown
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
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe*',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                      labelText: 'Confirmez le mot de passe*',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        allowMultiple: false,
                      );

                      if (result != null) {
                        PlatformFile file = result.files.first;
                        setState(() {
                          _selectedPhoto = html.File([file.bytes!], file.name);
                          _photoBytes =
                              file.bytes; // Save the photo bytes for preview
                        });
                      }
                    },
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
                        child: _photoBytes == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      color: Colors.grey.shade600, size: 40),
                                  SizedBox(height: 10),
                                  Text(
                                    'Sélectionner une photo',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            : Image.memory(
                                _photoBytes!,
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
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                        allowMultiple: false,
                      );

                      if (result != null) {
                        PlatformFile file = result.files.first;
                        setState(() {
                          _selectedDiplome =
                              html.File([file.bytes!], file.name);
                        });
                      }
                    },
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
                        child: _selectedDiplome == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_present,
                                      color: Colors.grey.shade600, size: 40),
                                  SizedBox(height: 10),
                                  Text(
                                    'Sélectionner un diplôme ',
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
          ],
        );
      },
    );
  }

  Widget _buildDepartementDropdown() {
    final DepartementController departementController =
        Get.put(DepartementController());
    final SpecialiteController specialiteController =
        Get.put(SpecialiteController());

    return Obx(() {
      final departements = departementController.departements;

      print("Departements: ${departements.map((d) => d.nom).toList()}");
      print("Selected Department: ${_departementController}");

      return StatefulBuilder(builder: (context, setState) {
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Département*',
            border: OutlineInputBorder(),
          ),
          value:
              // _departementController != null &&
              //         departements.any((departement) =>
              //             departement.nom == _departementController)
              //     ?
              _departementController,
          // : null,
          onChanged: (String? newValue) async {
            if (newValue != null) {
              setState(() {
                _specialiteController = null;
                // Clear the selected specialty
                _departementController = newValue; // Update selected department
              });

              // Find the department object based on its name
              final selectedDepartement = departements
                  .firstWhere((departement) => departement.nom == newValue);

              // Fetch specialties by the selected department ID
              await specialiteController.fetchSpecialitesByDepartement(
                  selectedDepartement.idDepartement);
            }
          },
          items: departements.isNotEmpty
              ? departements
                  .map((departement) => DropdownMenuItem<String>(
                        value: departement.nom,
                        child: Text(departement.nom),
                      ))
                  .toList()
              : [DropdownMenuItem(value: null, child: Text('No Departments'))],
          validator: (value) {
            if (value == null) {
              return 'Please select a department';
            }
            return null;
          },
        );
      });
    });
  }

  ///
  ///
  Widget _buildSpecialiteDropdown() {
    final SpecialiteController specialiteController =
        Get.put(SpecialiteController());

    return Obx(() {
      final specialites = specialiteController.specialitesByDepartement;

      print("Specialites: ${specialites.map((s) => s.nom).toList()}");
      print("Selected Specialty: ${_specialiteController}");

      return StatefulBuilder(builder: (context, setState) {
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Spécialité*',
            border: OutlineInputBorder(),
          ),
          value:
              //  _specialiteController != null &&
              //         specialites.any(
              //             (specialite) => specialite.nom == _specialiteController)
              //     ?
              _specialiteController,
          // : null,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _specialiteController = newValue;
              }); // Update selected specialty
            }
          },
          items: specialites.isNotEmpty
              ? specialites
                  .map((specialite) => DropdownMenuItem<String>(
                        value: specialite.nom,
                        child: Text(specialite.nom),
                      ))
                  .toList()
              : [DropdownMenuItem(value: null, child: Text('Spécialité'))],
          validator: (value) {
            if (value == null) {
              return 'Please select a specialty';
            }
            return null;
          },
        );
      });
    });
  }
}
