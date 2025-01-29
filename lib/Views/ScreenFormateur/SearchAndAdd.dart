import 'dart:typed_data'; // Required for handling Uint8List
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:webpfe/controllers/DepartementController.dart';
import 'package:webpfe/controllers/FormateurController.dart';
import 'package:webpfe/controllers/SpecialiteController.dart';

class SearchAndAdd extends StatefulWidget {
  @override
  _SearchAndAddState createState() => _SearchAndAddState();
}

class _SearchAndAddState extends State<SearchAndAdd> {


   final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final SpecialiteController specialiteController =
        Get.put(SpecialiteController());
    specialiteController.fetchSpecialites();

    final DepartementController departementController =
        Get.put(DepartementController());
    departementController.fetchDepartements();

    _searchController.addListener(() {
      _formateurController.filterFormateurs(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final FormateurController _formateurController =
      Get.put(FormateurController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  String? _specialiteController;
  String? _departementController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Uint8List? _selectedPhotoBytes;
  String? _photoFilename;
  bool _isPasswordVisible = false;

  void _pickPhoto() async {
    final pickedFile = await ImagePickerWeb.getImageAsBytes();
    if (pickedFile != null) {
      setState(() {
        _selectedPhotoBytes = pickedFile;
        _photoFilename = "formateur_photo.png";
      });
      debugPrint(" ${_photoFilename}");
    } else {
      print("No image selected");
    }
  }

  void _submitFormateur() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedPhotoBytes == null) {
        Get.snackbar('Error', 'Veuillez sélectionner une photo');
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        Get.snackbar('Error', 'Les mots de passe ne correspondent pas');
        return;
      }

      _formateurController
          .createFormateur(
        email: _emailController.text,
        password: _passwordController.text,
        nom: _nomController.text,
        prenom: _nomController.text,
        specialite: _specialiteController!,
        photoBytes: _selectedPhotoBytes!,
        photoFilename: _photoFilename!,
      )
          .then((_) {
        Get.snackbar('Succès', 'le formateur a été ajouté');

        _nomController.clear();
        _prenomController.clear();
        _specialiteController = null;
        _departementController = null;
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        setState(() {
          _selectedPhotoBytes = null;
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
                      : constraints.maxWidth * 0.7,
                  child: TextField(
                     controller: _searchController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search, color: Colors.black54),
                      hintText: 'Rechercher des formateurs...',
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
                ElevatedButton.icon(
                  onPressed: _showAddFormateurDialog,
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Ajouter un formateur',
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
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
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
                            'Ajouter un formateur',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _selectedPhotoBytes = null;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildFormFields(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _submitFormateur,
                            child: Text('Ajouter',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF228D6D),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildTextField(
                      controller: _nomController, labelText: 'Name*'),
                  SizedBox(height: 10),
                  _buildTextField(
                      controller: _prenomController, labelText: 'Prenom*'),
                  SizedBox(height: 10),
                  _buildDepartementDropdown(),
                  SizedBox(height: 10),
                  _buildSpecialiteDropdown(),
                  SizedBox(height: 10),
                  _buildEmailField(
                      controller: _emailController, labelText: 'Email*'),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPasswordField(
                            controller: _passwordController,
                            labelText: 'Mot de passe*'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildPasswordField(
                            controller: _confirmPasswordController,
                            labelText: 'Confirmer mot de passe*'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            _buildImagePicker(),
          ],
        ),
      ],
    );
  }

  Widget _buildDepartementDropdown() {
    final DepartementController departementController =
        Get.put(DepartementController());
    final SpecialiteController specialiteController =
        Get.put(SpecialiteController());

    return Obx(() {
      final departements = departementController.departements;

      print("Département: ${departements.map((d) => d.nom).toList()}");
      print("Département sélectionné: ${_departementController}");

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
              return 'Veuillez sélectionner un département';
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
              : [DropdownMenuItem(value: null, child: Text(' Specialité')),],
          validator: (value) {
            if (value == null) {
              return 'Veuillez sélectionner une spécialité';
            }
            return null;
          },
        );
      });
    });
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
          return 'Veuillez saisir $labelText';
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
          return 'Veuillez saisir votre e-mail';
        }
        if (!value.contains('@')) {
          return 'Veuillez saisir une adresse e-mail valide';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
      {required TextEditingController controller, required String labelText}) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: labelText,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker() {
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () async {
          final pickedFile = await ImagePickerWeb.getImageAsBytes();
          if (pickedFile != null) {
            setState(() {
              _selectedPhotoBytes = pickedFile;
              _photoFilename = "formateur_photo.png";
            });
            debugPrint(" ${_photoFilename}");
          } else {
            print("Aucune image sélectionnée");
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: Center(
            child: _selectedPhotoBytes == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt,
                          color: Colors.grey.shade600, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        ' sélectionner une photo',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 16),
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
    });
  }
}
// Link to FormateurController
