import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/ScreenFormateur/SearchAndAdd.dart';
import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/controllers/FormateurController.dart';

class AdminDashboardFormateur extends StatefulWidget {
  @override
  _AdminDashboardFormateurState createState() =>
      _AdminDashboardFormateurState();
}

class _AdminDashboardFormateurState extends State<AdminDashboardFormateur> {
  final FormateurController _formateurController =
      Get.put(FormateurController());
  int selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _formateurController
        .fetchAllFormateurs(); // Fetch all formateurs when the screen is loaded
  }

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // backgroundColor: const Color.fromARGB(255, 245, 244, 244),
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

class MainContent extends StatefulWidget {
  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  final FormateurController _formateurController = Get.find();
  Uint8List? _selectedPhotoForUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: const Color.fromARGB(255, 245, 244, 244),
      appBar: CustomAppBar(),
      body: Container(
        color: Colors.white,
        //color: const Color.fromARGB(255, 245, 244, 244),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Formateurs',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF228D6D)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchAndAdd(),
                const SizedBox(height: 20),
                Obx(() {
                  if (_formateurController.isLoading.value) {
                    return shimmerTable();
                  } else if (_formateurController.filteredFormateurs.isEmpty) {
                    return const Center(
                        child: Text(
                      'Aucun formateur trouvé',
                      style: TextStyle(color: Colors.grey),
                    ));
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
                          columnSpacing: 18,
                          columns: const [
                            DataColumn(label: Text('Nom')),
                            DataColumn(label: Text('Prénom')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Spécialité')),
                            DataColumn(label: Text('Département')),
                            DataColumn(label: Text('Photo')),
                            DataColumn(label: Text('Statut')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: _formateurController.filteredFormateurs
                              .map((formateur) {
                            return DataRow(cells: [
                              DataCell(Text(formateur.nom ?? '')),
                              DataCell(Text(formateur.prenom ?? '')),
                              DataCell(Text(formateur.email ?? '')),
                              DataCell(Text(formateur.specialite.nom ?? '')),
                              DataCell(Text(
                                  formateur.specialite.departement.nom ?? '')),
                              DataCell(
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: formateur.photo != null &&
                                          formateur.photo.isNotEmpty
                                      ? NetworkImage(formateur.photo)
                                      : const AssetImage(
                                              'assets/default-avatar.png')
                                          as ImageProvider,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              DataCell(Switch(
                                activeColor:
                                    const Color.fromARGB(255, 48, 112, 101),
                                value: formateur.active ?? false,
                                onChanged: (bool newValue) {
                                  _formateurController.updateFormateur(
                                    id: formateur.id,
                                    nom: formateur.nom,
                                    prenom: formateur.prenom,
                                    specialite: formateur.specialite.nom,
                                    email: formateur.email,
                                    active: newValue,
                                  );
                                },
                              )),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showFormateurDetailsDialog(
                                          context, formateur.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context,
                                          formateur.id, formateur.email);
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

  Widget shimmerTable() {
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
      child: Column(
        children: List.generate(5, (index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 50, height: 16, color: Colors.grey[300]),
                  Container(width: 50, height: 16, color: Colors.grey[300]),
                  Container(width: 100, height: 16, color: Colors.grey[300]),
                  Container(width: 80, height: 16, color: Colors.grey[300]),
                  Container(width: 80, height: 16, color: Colors.grey[300]),
                  Container(width: 50, height: 16, color: Colors.grey[300]),
                  Container(width: 50, height: 16, color: Colors.grey[300]),
                  Container(width: 100, height: 16, color: Colors.grey[300]),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Other helper methods (show dialogs) remain unchanged

  // Helper method to show formateur details dialog
  void _showFormateurDetailsDialog(BuildContext context, int formateurId) {
    _formateurController.getFormateurDetails(formateurId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_formateurController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          var details = _formateurController.formateurDetails;
          bool isActive = details.value!.active ?? false;

          return Dialog(
            insetPadding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Détails du Formateur',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF228D6D),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: TextEditingController(
                                    text: details.value!.nom ?? ''),
                                decoration: InputDecoration(labelText: 'Nom*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(
                                    text: details.value!.prenom ?? ''),
                                decoration:
                                    InputDecoration(labelText: 'Prenom*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(
                                    text: details.value!.specialite.nom ?? ''),
                                decoration:
                                    InputDecoration(labelText: 'Spécialité*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(
                                    text: details.value!.specialite.departement
                                            .nom ??
                                        ''),
                                decoration:
                                    InputDecoration(labelText: 'Departement*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(
                                    text: details.value!.email ?? ''),
                                decoration:
                                    InputDecoration(labelText: 'Email*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              // Row(
                              //   children: [
                              //     Text('Active Status: '),
                              //     Switch(
                              //       activeColor: isActive
                              //           ? Color.fromARGB(255, 105, 156, 148)
                              //           : Colors.grey, // Active status color
                              //       value: isActive, // Display active status
                              //       onChanged: null, // Read-only in details
                              //     ),
                              //     Text(
                              //       isActive ? "Active" : "Inactive",
                              //       style: TextStyle(
                              //         color: isActive
                              //             ? Color.fromARGB(255, 105, 156, 148)
                              //             : Colors.red,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: details.value!.photo != null &&
                                  details.value!.photo.isNotEmpty
                              ? Image.network(details.value!.photo,
                                  fit: BoxFit.cover)
                              : Icon(Icons.person,
                                  size: 100, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Fermer',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF228D6D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  // Helper method to show update formateur dialog
  void _showUpdateFormateurDialog(BuildContext context, int formateurId) {
    _formateurController.getFormateurDetails(formateurId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_formateurController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          var details = _formateurController.formateurDetails;
          final TextEditingController nomController =
              TextEditingController(text: details.value!.nom ?? '');
          final TextEditingController prenomController =
              TextEditingController(text: details.value!.prenom ?? '');
          final TextEditingController emailController =
              TextEditingController(text: details.value!.email ?? '');
          final TextEditingController specialiteController =
              TextEditingController(text: details.value!.specialite.nom ?? '');
          final TextEditingController departementController =
              TextEditingController(
                  text: details.value!.specialite.departement.nom ?? '');
          bool isActive = details.value!.active ?? false;

          return Dialog(
            insetPadding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Modifier Formateur',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF228D6D),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: nomController,
                                    decoration:
                                        InputDecoration(labelText: 'Nom*'),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: prenomController,
                                    decoration:
                                        InputDecoration(labelText: 'Prenom*'),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: specialiteController,
                                    decoration: InputDecoration(
                                        labelText: 'Spécialité*'),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: departementController,
                                    decoration: InputDecoration(
                                        labelText: 'Departement*'),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: emailController,
                                    decoration:
                                        InputDecoration(labelText: 'Email*'),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text('Active Status: '),
                                      Switch(
                                        activeColor:
                                            Color.fromARGB(255, 48, 112, 101),
                                        value: isActive, // Active status toggle
                                        onChanged: (bool newValue) {
                                          setState(() {
                                            isActive = newValue;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  // Select new image for update
                                  _selectPhotoForUpdate();
                                },
                                child: details.value!.photo != null &&
                                        details.value!.photo.isNotEmpty
                                    ? Image.network(details.value!.photo,
                                        fit: BoxFit.cover)
                                    : Icon(Icons.person,
                                        size: 100, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              _formateurController.updateFormateur(
                                id: formateurId,
                                nom: nomController.text,
                                prenom: prenomController.text,
                                email: emailController.text,
                                specialite: specialiteController.text,
                                active: isActive,
                                photoBytes:
                                    _selectedPhotoForUpdate, // New photo if updated
                                photoFilename: 'updated_photo.png',
                              );
                              Navigator.of(context).pop();
                            },
                            child: Text('Enregistrer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF228D6D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  // Helper method to select a photo for updating formateur
  void _selectPhotoForUpdate() async {
    // Code to pick a photo (e.g., using ImagePickerWeb or similar for web)
  }

  // Helper method to show delete confirmation dialog
  void _showDeleteConfirmationDialog(
      BuildContext context, int formateurId, String formateurEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm la suppression'),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer le formateur par e-mail $formateurEmail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Non',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 200, 202, 202),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _formateurController.deleteFormateur(formateurId);
                _formateurController.fetchAllFormateurs();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Oui',
                style: TextStyle(color: Color.fromARGB(255, 211, 209, 209)),
              ),
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
