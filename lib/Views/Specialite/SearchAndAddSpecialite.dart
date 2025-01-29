import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/controllers/SpecialiteController.dart';
import 'package:webpfe/controllers/DepartementController.dart';

class SearchAndAddSpecialite extends StatefulWidget {
  @override
  _SearchAndAddState createState() => _SearchAndAddState();
}

class _SearchAndAddState extends State<SearchAndAddSpecialite> {
  final SpecialiteController _specialiteController = Get.find();
  final DepartementController _departementController =
      Get.put(DepartementController());
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedDepartement;




  @override
  void initState() {
    super.initState();
    _departementController.fetchDepartements();
    _searchController.addListener(() {
      _specialiteController.filterSpecialites(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }



  // Open dialog to create a specialite
  void _showCreateSpecialiteDialog() {
    _nomController.clear();
    _descriptionController.clear();
    _selectedDepartement = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ajouter une spécialité',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        labelText: 'Nom*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir le nom';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir la description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (_departementController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DropdownButtonFormField<String>(
                        value: _selectedDepartement,
                        decoration: const InputDecoration(
                          labelText: 'Département*',
                          border: OutlineInputBorder(),
                        ),
                        items: _departementController.departements
                            .map((departement) => DropdownMenuItem<String>(
                                  value: departement.nom,
                                  child: Text(departement.nom),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartement = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner un département';
                          }
                          return null;
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _submitCreateSpecialite,
                          child: const Text('Ajouter',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF228D6D),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annuler',
                              style: TextStyle(color: Colors.white)),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
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

  // Submit the create specialite form
  void _submitCreateSpecialite() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _specialiteController.createSpecialite(
          _nomController.text,
          _descriptionController.text,
          _selectedDepartement!,
        );
        Navigator.of(context).pop(); // Close dialog on success
        Get.snackbar('Success', 'Specialite created successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to create specialite');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width:
                  constraints.maxWidth > 800 ? 700 : constraints.maxWidth * 0.7,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher des spécialités...',
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 241, 240, 240),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showCreateSpecialiteDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Ajouter une spécialité',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF228D6D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
