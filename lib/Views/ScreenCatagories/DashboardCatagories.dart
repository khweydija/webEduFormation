import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/ScreenCatagories/SearchAndAddc.dart';
import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/controllers/catagoriesController.dart';

class AdminDashboardCatagorie extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboardCatagorie> {
  final CategorieController _categorieController = Get.put(CategorieController());
  int selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _categorieController.fetchCategories();
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

class MainContent extends StatelessWidget {
  final CategorieController _categorieController = Get.find();

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
                          'Gestion des Catégories',
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
                SearchAndAddc(),
                SizedBox(height: 20),
                Obx(() {
                  if (_categorieController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (_categorieController.categories.isEmpty) {
                    return Center(child: Text('No categories found'));
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
                          columns: [
                            DataColumn(label: Text('Designation')), // Designation column first
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: _categorieController.categories.map((categorie) {
                            return DataRow(cells: [
                              DataCell(Text(categorie['designation'] ?? '')),  // Designation first
                              DataCell(Text(categorie['description'] ?? '')),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.visibility, color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showCategorieDetailsDialog(context, categorie['id']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showUpdateCategorieDialog(context, categorie['id']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, categorie['id']);
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

  void _showCategorieDetailsDialog(BuildContext context, int categorieId) {
    _categorieController.getCategorieById(categorieId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_categorieController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          var details = _categorieController.categorieDetails;
          return Dialog(
            insetPadding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6, // Adjust dialog width
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimized height
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Détails de la Catégorie',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF228D6D),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: TextEditingController(
                        text: details['designation'] ?? ''),  // Designation first
                    decoration: InputDecoration(labelText: 'Designation'),
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(
                        text: details['description'] ?? ''),
                    decoration: InputDecoration(labelText: 'Description'),
                    readOnly: true,
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
          );
        });
      },
    );
  }

  void _showUpdateCategorieDialog(BuildContext context, int categorieId) {
    _categorieController.getCategorieById(categorieId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_categorieController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          var details = _categorieController.categorieDetails;
          final TextEditingController designationController =
              TextEditingController(text: details['designation'] ?? '');  // Designation first
          final TextEditingController descriptionController =
              TextEditingController(text: details['description'] ?? '');

          return Dialog(
            insetPadding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6, // Adjust dialog width
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimized height
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modifier Catégorie',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF228D6D),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Designation first
                  TextField(
                    controller: designationController,
                    decoration: InputDecoration(labelText: 'Designation*'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description*'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Only update if there is a change
                          if (designationController.text != details['designation'] ||
                              descriptionController.text != details['description']) {
                            _categorieController.updateCategorie(
                              categorieId,
                              descriptionController.text,
                              designationController.text,
                            ).then((_) {
                              // Avoid 'Designation exists' check if the designation is unchanged
                              if (designationController.text != details['designation'] &&
                                  _categorieController.categories.any((cat) =>
                                      cat['designation'] == designationController.text)) {
                                Get.snackbar('Error', 'Designation already exists');
                              } else {
                                Get.snackbar('Success', 'Category updated successfully');
                                Navigator.of(context).pop();
                              }
                            });
                          } else {
                            Get.snackbar('Info', 'No changes detected');
                            Navigator.of(context).pop(); // Close the dialog
                          }
                        },
                        child: Text('Enregistrer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF228D6D),
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
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

  void _showDeleteConfirmationDialog(BuildContext context, int categorieId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer cette catégorie?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
            ElevatedButton(
              onPressed: () {
                _categorieController.deleteCategorie(categorieId);
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

  void _showCreateCategorieDialog(BuildContext context) {
    final TextEditingController designationController = TextEditingController();  // Designation first
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Créer Catégorie',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF228D6D),
                  ),
                ),
                SizedBox(height: 20),
                // Designation first
                TextField(
                  controller: designationController,
                  decoration: InputDecoration(labelText: 'Designation*'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description*'),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      _categorieController.createCategorie(
                        descriptionController.text,
                        designationController.text,
                      ).then((_) {
                        if (_categorieController.categories.any((cat) =>
                            cat['designation'] == designationController.text)) {
                          Get.snackbar('Error', 'Designation already exists');
                        } else {
                          Get.snackbar('Success', 'Category created successfully');
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    child: Text('Créer'),
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
    );
  }
}
