import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:webpfe/controllers/employeController.dart';
import 'package:webpfe/controllers/formation_controller.dart';
import 'package:webpfe/models/Certification.dart';

import 'package:webpfe/models/Formation.dart';

import '../../controllers/CertificationController.dart';

class SearchAndAddCertification extends StatefulWidget {
  @override
  _SearchAndAddCertificationState createState() =>
      _SearchAndAddCertificationState();
}

class _SearchAndAddCertificationState extends State<SearchAndAddCertification> {
  final EmployeController _employeController = Get.put(EmployeController());
  final FormationController _formationController =
      Get.put(FormationController());

  final CertificationController _certificationController =
      Get.put(CertificationController());

  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _statutController = TextEditingController();
  DateTime? _dateObtention;
  Employe? _selectedEmploye;
  Formation? _selectedFormation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _employeController.fetchAllEmployes();
    _formationController.fetchFormationList();
  }

  void _searchCertifications() async {
    if (_searchController.text.isNotEmpty) {
      _certificationController.fetchCertifications();
    } else {
      _certificationController.fetchCertifications();
    }
  }

  void _showCreateCertificationDialog() {
    _titreController.clear();
    _notesController.clear();
    _statutController.clear();
    _dateObtention = null;
    _selectedEmploye = null;
    _selectedFormation = null;

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
                    Obx(
                      () => DropdownButtonFormField<Employe>(
                        value: _selectedEmploye,
                        items: _employeController.employes.map((employe) {
                          return DropdownMenuItem<Employe>(
                            value: employe,
                            child: Text('${employe.nom} ${employe.prenom}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEmploye = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Employé*',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner un employé';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => DropdownButtonFormField<Formation>(
                        value: _selectedFormation,
                        items: _formationController.formations.map((formation) {
                          return DropdownMenuItem<Formation>(
                            value: formation,
                            child: Text(formation.titre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFormation = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Formation*',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner une formation';
                          }
                          return null;
                        },
                      ),
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
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors
                                          .teal, // Couleur principale (boutons et en-tête)
                                      onPrimary: Colors
                                          .white, // Texte sur fond primary
                                      onSurface: Colors
                                          .teal, // Couleur du texte principal (inclut "Select date")
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors
                                            .teal, // Couleur des boutons "OK" et "Cancel"
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (picked != null && picked != _dateObtention) {
                              setState(() {
                                _dateObtention = picked;
                              });
                            }
                          },
                          child: const Text('Choisir une date',
                              style: TextStyle(color: Colors.teal)),
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
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: const Text('Annuler'),
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

  void _submitCreateCertification() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (_selectedFormation == null) {
          Get.snackbar('Erreur', 'Veuillez sélectionner une formation');
          return;
        }

        final certification = PostCertification(
          titre: _titreController.text,
          notes: _notesController.text,
          statut: _statutController.text,
          dateObtention: _dateObtention!,
          formationId: _selectedFormation!.id!, // Ensure it's not null
          employeId: _selectedEmploye!.id,
        );

        await _certificationController.createCertification(certification);
        Navigator.of(context).pop();
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
                onChanged: (query) {
                  _certificationController
                      .filterCertifications(query); // Filter certifications
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher des certifications...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
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
