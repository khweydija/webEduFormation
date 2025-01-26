import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/controllers/certificationController.dart';
import 'package:webpfe/models/Certification.dart';

class SearchAndAddCertification extends StatefulWidget {
  @override
  _SearchAndAddCertificationState createState() =>
      _SearchAndAddCertificationState();
}

class _SearchAndAddCertificationState extends State<SearchAndAddCertification> {
  final CertificationController _certificationController = Get.find<CertificationController>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _statutController = TextEditingController();
  final TextEditingController _formationIdController = TextEditingController();
  final TextEditingController _employeIdController = TextEditingController();
  DateTime? _dateObtention;
  final _formKey = GlobalKey<FormState>();

  // Search certifications
  void _searchCertifications() async {
    if (_searchController.text.isNotEmpty) {
      // Implement search logic if required
      _certificationController.fetchCertifications();
    } else {
      _certificationController.fetchCertifications();
    }
  }

  // Open dialog to create a certification
  void _showCreateCertificationDialog() {
    _titreController.clear();
    _notesController.clear();
    _statutController.clear();
    _formationIdController.clear();
    _employeIdController.clear();
    _dateObtention = null;

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
                          'Ajouter une certification',
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
                      controller: _titreController,
                      decoration: const InputDecoration(
                        labelText: 'Titre*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le titre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer les notes';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _statutController,
                      decoration: const InputDecoration(
                        labelText: 'Statut*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le statut';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _formationIdController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Formation ID*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer l\'ID de la formation';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _employeIdController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Employé ID*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer l\'ID de l\'employé';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _dateObtention != null
                                ? 'Date: ${_dateObtention!.toLocal()}'
                                : 'Date d\'obtention*',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != _dateObtention) {
                              setState(() {
                                _dateObtention = picked;
                              });
                            }
                          },
                          child: const Text('Choisir une date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _submitCreateCertification,
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
                          child: const Text('Annuler'),
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

  // Submit the create certification form
  void _submitCreateCertification() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final certification = PostCertification(
          titre: _titreController.text,
          notes: _notesController.text,
          statut: _statutController.text,
          dateObtention: _dateObtention!,
          formationId: int.parse(_formationIdController.text),
          employeId: int.parse(_employeIdController.text),
        );
        await _certificationController.createCertification(certification);
        Navigator.of(context).pop(); // Close dialog on success
        Get.snackbar('Succès', 'Certification créée avec succès');
      } catch (e) {
        Get.snackbar('Erreur', 'Échec de la création de la certification');
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
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.black54),
                    onPressed: _searchCertifications,
                  ),
                  hintText: 'Rechercher des certifications...',
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 241, 240, 240),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showCreateCertificationDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Ajouter une certification',
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
