import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/Views/Specialite/SearchAndAddSpecialite.dart';
import 'package:webpfe/controllers/DepartementController.dart';
import 'package:webpfe/controllers/SpecialiteController.dart';

class AdminDashboardSpecialite extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboardSpecialite> {
  final SpecialiteController _specialiteController =
      Get.put(SpecialiteController());
  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _specialiteController.fetchSpecialites();
  }

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 244, 244),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (constraints.maxWidth > 800)
                Sidebar(
                  selectedIndex: selectedIndex,
                  onItemSelected: onItemSelected,
                ),
              Expanded(
                child: MainContent(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  final SpecialiteController _specialiteController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 244, 244),
      appBar: CustomAppBar(),
      body: Container(
        color: const Color.fromARGB(255, 245, 244, 244),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gestion des Spécialités',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF228D6D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchAndAddSpecialite(),
                const SizedBox(height: 20),
                Obx(() {
                  if (_specialiteController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_specialiteController.specialites.isEmpty) {
                    return const Center(child: Text('No specialities found'));
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 100,
                          columns: const [
                            DataColumn(label: Text('Nom')),
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Département')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: _specialiteController.specialites
                              .map((specialite) {
                            return DataRow(cells: [
                              DataCell(Text(specialite.nom)),
                              DataCell(Text(specialite.description)),
                              DataCell(Text(specialite.departement.nom)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showSpecialiteDetailsDialog(
                                          context, specialite.idSpecialite);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showUpdateSpecialiteDialog(
                                          context, specialite.idSpecialite);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, specialite.idSpecialite);
                                    },
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSpecialiteDetailsDialog(BuildContext context, int specialiteId) {
    _specialiteController.getSpecialiteById(specialiteId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_specialiteController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = _specialiteController.specialiteDetails.value;
          if (details == null) return const SizedBox();

          return Dialog(
            insetPadding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Détails de la Spécialité',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF228D6D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: TextEditingController(text: details.nom),
                    decoration: const InputDecoration(labelText: 'Nom'),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller:
                        TextEditingController(text: details.description),
                    decoration: const InputDecoration(labelText: 'Description'),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller:
                        TextEditingController(text: details.departement.nom),
                    decoration: const InputDecoration(labelText: 'Département'),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Fermer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF228D6D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showUpdateSpecialiteDialog(BuildContext context, int specialiteId) {
    final DepartementController _departementController =
        Get.put(DepartementController());
    _specialiteController.getSpecialiteById(specialiteId);
    _departementController.fetchDepartements();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_specialiteController.isLoading.value ||
              _departementController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = _specialiteController.specialiteDetails.value;
          if (details == null) return const SizedBox();

          final TextEditingController nomController =
              TextEditingController(text: details.nom);
          final TextEditingController descriptionController =
              TextEditingController(text: details.description);
          String? selectedDepartement = details.departement.nom;

          return Dialog(
            insetPadding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Modifier Spécialité',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF228D6D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nomController,
                    decoration: const InputDecoration(labelText: 'Nom*'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Description*'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedDepartement,
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
                      selectedDepartement = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a department';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedDepartement != null) {
                            await _specialiteController.updateSpecialite(
                              specialiteId,
                              nomController.text,
                              descriptionController.text,
                              selectedDepartement!,
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Enregistrer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF228D6D),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int specialiteId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content:
              const Text('Voulez-vous vraiment supprimer cette spécialité?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _specialiteController.deleteSpecialite(specialiteId);
                Navigator.of(context).pop();
              },
              child: const Text('Oui'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 23, 134, 116),
              ),
            ),
          ],
        );
      },
    );
  }
}
