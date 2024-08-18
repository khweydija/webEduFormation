import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/Views/Dashboard/SearchAndAdd.dart';
import 'package:webpfe/Views/Dashboard/Sidebar.dart';
import 'package:webpfe/controllers/FormateurController/AffichageFController.dart';
import 'package:webpfe/controllers/FormateurController/DeleteFController.dart';
import 'package:webpfe/controllers/FormateurController/GetFDetailsController.dart';
import 'package:webpfe/controllers/FormateurController/UpdateFController.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AffichageFController _affichageFController =
      Get.put(AffichageFController());
  int selectedIndex = 1; // Default selected index

  @override
  void initState() {
    super.initState();
    _affichageFController
        .fetchFormateurs(); // Fetch formateurs when the dashboard loads
  }

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
          255, 245, 244, 244), // Background color for the entire screen
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (constraints.maxWidth > 800)
                Sidebar(
                  selectedIndex: selectedIndex,
                  onItemSelected: onItemSelected,
                ), // Sidebar inherits the same background color
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
  final AffichageFController _affichageFController = Get.find();
  final DeleteFormateurController _deleteFormateurController =
      Get.put(DeleteFormateurController());
  final GetFormateurDetailsController _getFormateurDetailsController =
      Get.put(GetFormateurDetailsController());
  final UpdateFController _updateFormateurController =
      Get.put(UpdateFController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
          255, 245, 244, 244), // Background color for the content area
      appBar: AppBar(
        backgroundColor: Color.fromARGB(
            255, 245, 244, 244), // Background color for the app bar
        elevation: 0, // Removes the shadow under the AppBar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello Admin',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Have a nice day',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {},
                ),
                CircleAvatar(
                    // backgroundImage: AssetImage('assets/profile.jpg'), // Replace with your image
                    ),
                SizedBox(width: 10),
                Text(
                  'M. Inam',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color: Color.fromARGB(
            255, 245, 244, 244), // Background color for the content area
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
                  if (_affichageFController.formateurs.isEmpty) {
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
                            DataColumn(label: Text('Spécialité')),
                            DataColumn(label: Text('Departement')),
                            DataColumn(label: Text('Photo')),
                            DataColumn(label: Text('Create Date')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows:
                              _affichageFController.formateurs.map((formateur) {
                            return DataRow(cells: [
                              DataCell(Text(formateur['nom'] ?? '')),
                              DataCell(Text(formateur['email'] ?? '')),
                              DataCell(Text(formateur['specialite'] ?? '')),
                              DataCell(Text(formateur['departement'] ?? '')),
                              DataCell(
                                formateur['photo'] != null &&
                                        formateur['photo'].isNotEmpty
                                    ? Image.network(
                                        formateur['photo'],
                                        width: 100,
                                        height: 100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          print(error);
                                          return Icon(Icons.error,
                                              color: Colors.red);
                                        },
                                      )
                                    : Icon(Icons.person,
                                        size: 50, color: Colors.grey),
                              ),
                              DataCell(Text(formateur['createDate'] ?? '')),
                              DataCell(Text(formateur['status'] ?? '')),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.visibility,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showFormateurDetailsDialog(
                                          context, formateur['id']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showUpdateFormateurDialog(
                                          context, formateur['id']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
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

  void _showFormateurDetailsDialog(BuildContext context, int formateurId) {
    _getFormateurDetailsController.getFormateurDetails(formateurId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_getFormateurDetailsController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          var details = _getFormateurDetailsController.formateurDetails;
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
                      'Details du Formateur',
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
                              ? Image.network(
                                  'http://localhost:8080/' + details['photo'],
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

  void _showUpdateFormateurDialog(BuildContext context, int formateurId) {
    _getFormateurDetailsController.getFormateurDetails(formateurId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_getFormateurDetailsController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          var details = _getFormateurDetailsController.formateurDetails;
          final TextEditingController nomController =
              TextEditingController(text: details['nom'] ?? '');
          final TextEditingController emailController =
              TextEditingController(text: details['email'] ?? '');
          final TextEditingController passwordController =
              TextEditingController();
          final TextEditingController specialiteController =
              TextEditingController(text: details['specialite'] ?? '');
          final TextEditingController departementController =
              TextEditingController(text: details['departement'] ?? '');
          final TextEditingController confirmPasswordController =
              TextEditingController();
          String? selectedPhotoPath;

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
                                decoration: InputDecoration(labelText: 'Nom*'),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: specialiteController,
                                decoration:
                                    InputDecoration(labelText: 'Spécialité*'),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: departementController,
                                decoration:
                                    InputDecoration(labelText: 'Departement*'),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: emailController,
                                decoration:
                                    InputDecoration(labelText: 'Email*'),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: passwordController,
                                decoration:
                                    InputDecoration(labelText: 'Password*'),
                                obscureText: true,
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: confirmPasswordController,
                                decoration: InputDecoration(
                                    labelText: 'Confirm Password*'),
                                obscureText: true,
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
                              // Implement photo selection here
                              // Once selected, set `selectedPhotoPath`
                              selectedPhotoPath =
                                  await _selectPhoto(); // Example method, needs implementation
                            },
                            child: details['photo'] != null &&
                                    details['photo'].isNotEmpty
                                ? Image.network(
                                    'http://localhost:8080/' + details['photo'],
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
                          if (passwordController.text ==
                              confirmPasswordController.text) {
                            _updateFormateurController.updateFormateur(
                              id: formateurId,
                              nom: nomController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              specialite: specialiteController.text,
                              departement: departementController.text,
                              photoPath: selectedPhotoPath,
                            );
                            Navigator.of(context).pop();
                          } else {
                            Get.snackbar('Error', 'Passwords do not match');
                          }
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

  Future<String?> _selectPhoto() async {
    // Implement this method to select a photo from the device
    // Return the path of the selected photo
    return null; // Placeholder implementation
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, int formateurId, String formateurEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the formateur with email $formateurEmail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteFormateurController.deleteFormateur(formateurId);
                _affichageFController
                    .fetchFormateurs(); // Refresh the list after deletion
                Navigator.of(context).pop(); // Close the dialog
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
}
