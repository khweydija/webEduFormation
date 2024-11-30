import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  int selectedIndex = 1;

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
      backgroundColor: Color.fromARGB(255, 245, 244, 244),
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
  Uint8List? _selectedPhotoForUpdate; // Handle photo for update

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 244, 244),
      appBar: CustomAppBar(),
      body: Container(
        color: Color.fromARGB(255, 245, 244, 244),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gestion des Formateurs',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF228D6D)),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SearchAndAdd(),
                SizedBox(height: 20),
                Obx(() {
                  if (_formateurController.formateurs.isEmpty) {
                    return Center(child: CircularProgressIndicator());
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
                          columns: [
                            DataColumn(label: Text('Nom')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Spécialité')),
                            DataColumn(label: Text('Departement')),
                            DataColumn(label: Text('Photo')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows:
                              _formateurController.formateurs.map((formateur) {
                            return DataRow(cells: [
                              DataCell(Text(formateur['nom'] ?? '')),
                              DataCell(Text(formateur['email'] ?? '')),
                              DataCell(Text(formateur['specialite'] ?? '')),
                              DataCell(Text(formateur['departement'] ?? '')),
                              DataCell(
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: formateur['photo'] != null &&
                                          formateur['photo'].isNotEmpty
                                      ? NetworkImage(formateur['photo'])
                                      : AssetImage('assets/default-avatar.png')
                                          as ImageProvider,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              DataCell(Switch(
                                activeColor: Color.fromARGB(255, 48, 112, 101),
                                value: formateur['active'] ?? false,
                                onChanged: (bool newValue) {
                                  _formateurController.updateFormateur(
                                    id: formateur['id'],
                                    nom: formateur['nom'],
                                    specialite: formateur['specialite'],
                                    departement: formateur['departement'],
                                    email: formateur['email'],
                                    active: newValue, // Toggle active status
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
                                          context, formateur['id']);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showUpdateFormateurDialog(
                                          context, formateur['id']);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context,
                                          formateur['id'], formateur['email']);
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
          bool isActive = details['active'] ?? false;

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
                                    text: details['nom'] ?? ''),
                                decoration: InputDecoration(labelText: 'Nom*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(
                                    text: details['specialite'] ?? ''),
                                decoration:
                                    InputDecoration(labelText: 'Spécialité*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(
                                    text: details['departement'] ?? ''),
                                decoration:
                                    InputDecoration(labelText: 'Departement*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(
                                    text: details['email'] ?? ''),
                                decoration:
                                    InputDecoration(labelText: 'Email*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text('Active Status: '),
                                  Switch(
                                    activeColor: isActive
                                        ? Color.fromARGB(255, 105, 156, 148)
                                        : Colors.grey, // Active status color
                                    value: isActive, // Display active status
                                    onChanged: null, // Read-only in details
                                  ),
                                  Text(
                                    isActive ? "Active" : "Inactive",
                                    style: TextStyle(
                                      color: isActive
                                          ? Color.fromARGB(255, 105, 156, 148)
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                          child: details['photo'] != null &&
                                  details['photo'].isNotEmpty
                              ? Image.network(details['photo'],
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
              TextEditingController(text: details['nom'] ?? '');
          final TextEditingController emailController =
              TextEditingController(text: details['email'] ?? '');
          final TextEditingController specialiteController =
              TextEditingController(text: details['specialite'] ?? '');
          final TextEditingController departementController =
              TextEditingController(text: details['departement'] ?? '');
          bool isActive = details['active'] ?? false;

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
                                child: details['photo'] != null &&
                                        details['photo'].isNotEmpty
                                    ? Image.network(details['photo'],
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
                                email: emailController.text,
                                specialite: specialiteController.text,
                                departement: departementController.text,
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
          title: Text('Confirm Deletion'),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer le formateur par e-mail $formateurEmail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
            ElevatedButton(
              onPressed: () {
                _formateurController.deleteFormateur(formateurId);
                _formateurController.fetchAllFormateurs();
                Navigator.of(context).pop();
              },
              child: Text('Oui'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 23, 134, 116),
              ),
            ),
          ],
        );
      },
    );
  }
}
