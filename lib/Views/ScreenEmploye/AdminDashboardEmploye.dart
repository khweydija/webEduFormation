import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/ScreenEmploye/SearchAndAddEmploye.dart';
import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/controllers/EmployeController.dart'; 

class AdminDashboardEmploye extends StatefulWidget {
  @override
  _AdminDashboardEmployeState createState() => _AdminDashboardEmployeState();
}

class _AdminDashboardEmployeState extends State<AdminDashboardEmploye> {
  final EmployeController _employeController = Get.put(EmployeController());
  int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _employeController.fetchAllEmployes(); // Fetch all employees on page load
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
  final EmployeController _employeController = Get.find();
  XFile? _selectedPhoto;

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
                          'Gestion des Employés',
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
                SearchAndAddEmploye(),
                SizedBox(height: 20),
                Obx(() {
                  if (_employeController.employes.isEmpty) {
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
                          columnSpacing: 12,
                          columns: [
                            DataColumn(label: Text('Nom')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Departement')),
                            DataColumn(label: Text('Photo')),
                            DataColumn(label: Text('Diplome')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: _employeController.employes.map((employe) {
                            return DataRow(cells: [
                              DataCell(Text(employe['nom'] ?? '')),
                              DataCell(Text(employe['email'] ?? '')),
                              DataCell(Text(employe['departement'] ?? '')),
                              DataCell(
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: employe['photo'] != null && employe['photo'].isNotEmpty
                                      ? NetworkImage(employe['photo'])
                                      : AssetImage('assets/default-avatar.png') as ImageProvider,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              DataCell(
                                employe['diplome'] != null && employe['diplome'].isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          String encodedUrl = Uri.encodeFull(employe['diplome']); // Encode the URL
                                          _employeController.openDiplome(encodedUrl); // Open the encoded diplome URL
                                        },
                                        child: Text(
                                          'View Diplôme',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline),
                                        ),
                                      )
                                    : Text('No Diplôme'),
                              ),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.visibility, color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showEmployeDetailsDialog(context, employe['id']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showEditEmployeDialog(context, employe['id']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, employe['id'], employe['email']);
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

  void _showEmployeDetailsDialog(BuildContext context, int employeId) {
    _employeController.getEmployeById(employeId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_employeController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          var details = _employeController.selectedEmploye;
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
                      'Details de l\'Employé',
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
                                controller: TextEditingController(text: details['nom'] ?? ''),
                                decoration: InputDecoration(labelText: 'Nom*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(text: details['email'] ?? ''),
                                decoration: InputDecoration(labelText: 'Email*'),
                                readOnly: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: TextEditingController(text: details['departement'] ?? ''),
                                decoration: InputDecoration(labelText: 'Departement*'),
                                readOnly: true,
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
                          child: details['photo'] != null && details['photo'].isNotEmpty
                              ? Image.network(details['photo'], fit: BoxFit.cover)
                              : Icon(Icons.person, size: 100, color: Colors.grey),
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
                        child: Text('Fermer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF228D6D),
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

  void _showEditEmployeDialog(BuildContext context, int employeId) {
    _employeController.getEmployeById(employeId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_employeController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          var details = _employeController.selectedEmploye;
          final TextEditingController nomController = TextEditingController(text: details['nom'] ?? '');
          final TextEditingController emailController = TextEditingController(text: details['email'] ?? '');
          final TextEditingController departementController = TextEditingController(text: details['departement'] ?? '');

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
                      'Modifier Employé',
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
                                decoration: InputDecoration(labelText: 'Nom*'),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: departementController,
                                decoration: InputDecoration(labelText: 'Departement*'),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(labelText: 'Email*'),
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
                              _selectPhoto();
                            },
                            child: details['photo'] != null && details['photo'].isNotEmpty
                                ? Image.network(details['photo'], fit: BoxFit.cover)
                                : Icon(Icons.person, size: 100, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _employeController.updateEmploye(
                            id: employeId,
                            email: emailController.text,
                            nom: nomController.text,
                            departement: departementController.text,
                            active: true, 
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
            ),
          );
        });
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int employeId, String employeEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the employee with email $employeEmail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _employeController.deleteEmploye(employeId);
                _employeController.fetchAllEmployes(); 
                Navigator.of(context).pop(); 
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 23, 134, 116),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = pickedFile;
      });
    }
  }
}
