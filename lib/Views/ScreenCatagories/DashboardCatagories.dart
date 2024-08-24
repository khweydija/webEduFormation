import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/ScreenCatagories/SearchAndAddc.dart';
import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/controllers/catagoriesController.dart';


class AdminDashboardC extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboardC> {
  final CategorieController _categorieController =
      Get.put(CategorieController());
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
      appBar:CustomAppBar(),
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
                          columnSpacing: 12,
                          columns: [
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Designation')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: _categorieController.categories.map((categorie) {
                            return DataRow(cells: [
                              DataCell(Text(categorie['description'] ?? '')),
                              DataCell(Text(categorie['designation'] ?? '')),
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
              padding: EdgeInsets.all(20),
              child: Column(
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
                        text: details['description'] ?? ''),
                    decoration: InputDecoration(labelText: 'Description'),
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(
                        text: details['designation'] ?? ''),
                    decoration: InputDecoration(labelText: 'Designation'),
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
          final TextEditingController descriptionController =
              TextEditingController(text: details['description'] ?? '');
          final TextEditingController designationController =
              TextEditingController(text: details['designation'] ?? '');

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
                    'Modifier Catégorie',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF228D6D),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description*'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: designationController,
                    decoration: InputDecoration(labelText: 'Designation*'),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        _categorieController.updateCategorie(
                          categorieId,
                          descriptionController.text,
                          designationController.text,
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
}
