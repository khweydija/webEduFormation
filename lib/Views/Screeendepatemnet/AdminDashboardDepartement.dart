import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/Screeendepatemnet/SearchAndAddd.dart';

import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/controllers/DepartementController.dart';

class AdminDashboardDepartement extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboardDepartement> {
  final DepartementController _departementController = Get.put(DepartementController());
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _departementController.fetchDepartements();
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
  final DepartementController _departementController = Get.find();

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
                      'Gestion des Départements',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF228D6D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchAndAddd(),
                const SizedBox(height: 20),
                Obx(() {
                  if (_departementController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_departementController.departements.isEmpty) {
                    return const Center(child: Text('No departments found'));
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
                          columnSpacing: 200,
                          columns: const [
                            DataColumn(label: Text('Nom')),
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: _departementController.departements.map((departement) {
                            return DataRow(cells: [
                              DataCell(Text(departement.nom)),
                              DataCell(Text(departement.description)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility, color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDepartementDetailsDialog(context, departement.idDepartement);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showUpdateDepartementDialog(context, departement.idDepartement);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, departement.idDepartement);
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

  void _showDepartementDetailsDialog(BuildContext context, int departementId) {
    _departementController.getDepartementById(departementId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_departementController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = _departementController.departementDetails.value;
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
                    'Détails du Département',
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
                    controller: TextEditingController(text: details.description),
                    decoration: const InputDecoration(labelText: 'Description'),
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

  void _showUpdateDepartementDialog(BuildContext context, int departementId) {
    _departementController.getDepartementById(departementId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_departementController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = _departementController.departementDetails.value;
          if (details == null) return const SizedBox();

          final TextEditingController nomController =
              TextEditingController(text: details.nom);
          final TextEditingController descriptionController =
              TextEditingController(text: details.description);

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
                    'Modifier Département',
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
                    decoration: const InputDecoration(labelText: 'Description*'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _departementController.updateDepartement(
                            departementId,
                            nomController.text,
                            descriptionController.text,
                          );
                          Navigator.of(context).pop();
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

  void _showDeleteConfirmationDialog(BuildContext context, int departementId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Voulez-vous vraiment supprimer ce département?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _departementController.deleteDepartement(departementId);
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
