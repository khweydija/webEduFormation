import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
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
  int selectedIndex = 4;

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
      backgroundColor: Colors.white,
      //backgroundColor: const Color.fromARGB(255, 245, 244, 244),
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
  html.File? _selectedPhoto;
  html.File? _selectedDiplome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: const Color.fromARGB(255, 245, 244, 244),
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
                  children: const [
                    Text(
                      ' Employées',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF228D6D)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchAndAddEmploye(),
                const SizedBox(height: 20),
                Obx(() {
                  if (_employeController.isLoading.value) {
                    return shimmerTable();
                  } else if (_employeController.filteredEmployes.isEmpty) {
                    return const Center(
                        child:
                            Text('Aucun employé trouvé')); // No fallback text
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
                          columnSpacing: 16,
                          columns: const [
                            DataColumn(label: Text('Nom')),
                            DataColumn(label: Text('Prenom')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Departement')),
                            DataColumn(label: Text('Specialite')),
                            DataColumn(label: Text('Photo')),
                            DataColumn(label: Text('Diplome')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: _employeController.filteredEmployes
                              .map((employe) {
                            return DataRow(cells: [
                              DataCell(Text(employe.nom ?? '')),
                              DataCell(Text(employe.prenom ?? '')),
                              DataCell(Text(employe.email ?? '')),
                              DataCell(Text(
                                  employe.specialite.departement.nom ?? '')),
                              DataCell(Text(employe.specialite.nom ?? '')),
                              DataCell(
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: employe.photo != null &&
                                          employe.photo.isNotEmpty
                                      ? NetworkImage(employe.photo)
                                      : const AssetImage(
                                              'assets/default-avatar.png')
                                          as ImageProvider,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              DataCell(
                                employe.diplome != null &&
                                        employe.diplome.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: Color.fromARGB(
                                                255, 44, 71, 68)),
                                        onPressed: () {
                                          String encodedUrl =
                                              Uri.encodeFull(employe.diplome);
                                          _employeController
                                              .openDiplome(encodedUrl);
                                        },
                                      )
                                    : const Icon(Icons.close,
                                        color: Colors.red),
                              ),
                              DataCell(Switch(
                                value: employe.active ?? false,
                                onChanged: (bool newValue) {
                                  _employeController.updateEmploye(
                                    id: employe.id,
                                    email: employe.email,
                                    nom: employe.nom,
                                    prenom: employe.prenom,
                                    specialite: employe.specialite.nom,
                                    active: newValue,
                                  );
                                },
                                activeColor:
                                    const Color.fromARGB(255, 48, 112, 101),
                              )),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showEmployeDetailsDialog(
                                          context, employe.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context,
                                          employe.id, employe.email ?? '');
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

  // Helper methods for dialog boxes
  void _showDeleteConfirmationDialog(
      BuildContext context, int employeId, String employeEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer l\'employé avec l\'email $employeEmail?'),
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
                _employeController.deleteEmploye(employeId);
                _employeController.fetchAllEmployes();
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

  void _showEmployeDetailsDialog(BuildContext context, int employeId) {
    _employeController.getEmployeById(employeId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_employeController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          var details = _employeController.employeDetails;
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
                      'Détails de l\'Employé',
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
                                    InputDecoration(labelText: 'Prénom*'),
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
                              TextField(
                                controller: TextEditingController(
                                    text: details.value!.specialite.departement
                                            .nom ??
                                        ''),
                                decoration:
                                    InputDecoration(labelText: 'Département*'),
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
                              // Row(
                              //   children: [
                              //     Text('Statut Actif: '),
                              //     Switch(
                              //       activeColor: isActive
                              //           ? Color.fromARGB(255, 105, 156, 148)
                              //           : Colors.grey,
                              //       value: isActive,
                              //       onChanged: null,
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
                    // SizedBox(height: 20),
                    // details.value!.diplome != null &&
                    //         details.value!.diplome.isNotEmpty
                    //     ? InkWell(
                    //         onTap: () {
                    //           String encodedUrl =
                    //               Uri.encodeFull(details.value!.diplome);
                    //           _employeController.openDiplome(encodedUrl);
                    //         },
                    //         child: Text(
                    //           'Voir le Diplôme',
                    //           style: TextStyle(
                    //               color: Color.fromARGB(255, 51, 95, 91),
                    //               decoration: TextDecoration.underline),
                    //         ),
                    //       )
                    //     : Text('No Diplôme'),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Fermer',
                          style: TextStyle(color: Colors.white),
                        ),
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

          var details = _employeController.employeDetails;
          final TextEditingController nomController =
              TextEditingController(text: details.value!.nom ?? '');
          final TextEditingController prenomController =
              TextEditingController(text: details.value!.prenom ?? '');
          final TextEditingController emailController =
              TextEditingController(text: details.value!.email ?? '');
          final TextEditingController departementController =
              TextEditingController(text: details.value!.specialite.nom ?? '');
          bool isActive = details.value!.active ?? false;
          String? password;

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
                                  TextField(
                                    obscureText: true,
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Mot de passe',
                                      helperText:
                                          'Laissez vide si vous ne souhaitez pas changer le mot de passe',
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text('Active Status: '),
                                      Switch(
                                        activeColor:
                                            Color.fromARGB(255, 48, 112, 101),
                                        value: isActive,
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
                                  _selectPhoto();
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
                        GestureDetector(
                          onTap: () async {
                            _selectDiplome();
                          },
                          child: Center(
                            child: _selectedDiplome == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.file_present,
                                          color: Colors.grey.shade600,
                                          size: 40),
                                      SizedBox(height: 10),
                                      Text(
                                        'Tap to select a diplome (PDF)',
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
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              _employeController.updateEmploye(
                                id: employeId,
                                email: emailController.text,
                                nom: nomController.text,
                                prenom: prenomController.text,
                                specialite: departementController.text,
                                active: isActive,
                                password: password != null && password!.isEmpty
                                    ? null
                                    : password,
                                photo: _selectedPhoto,
                                diplome: _selectedDiplome,
                              );
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Enregistrer',
                            ),
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

  Future<void> _selectPhoto() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Accept image files only
    uploadInput.click(); // Trigger file picker

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        setState(() {
          _selectedPhoto = files.first; // Store the selected photo
        });
      }
    });
  }

  Future<void> _selectDiplome() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.pdf'; // Accept PDF files only
    uploadInput.click(); // Trigger file picker

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        setState(() {
          _selectedDiplome = files.first; // Store the selected diplome
        });
      }
    });
  }
}
