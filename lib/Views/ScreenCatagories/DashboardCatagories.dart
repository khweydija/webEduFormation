import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/ScreenCatagories/SearchAndAddc.dart';
import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/controllers/catagoriesController.dart';

class AdminDashboardCategorie extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboardCategorie> {
  final CategoryController _categoryController = Get.put(CategoryController());
  int selectedIndex = 5;

  @override
  void initState() {
    super.initState();
    _categoryController.fetchCategories(); // Fetch categories on page load
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

class MainContent extends StatelessWidget {
  final CategoryController _categoryController = Get.find();

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
                      ' Catégories',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF228D6D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchAndAddc(),
                const SizedBox(height: 20),
                Obx(() {
                  if (_categoryController.isLoading.value) {
                    return shimmerTable(); // Shimmer effect for loading state
                  } else if (_categoryController.categories.isEmpty) {
                    return const SizedBox.shrink(); // No fallback text
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
                            DataColumn(label: Text('Designation')),
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: _categoryController.categories.map((category) {
                            return DataRow(cells: [
                              DataCell(Text(category.designation)),
                              DataCell(Text(category.description)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showCategoryDetailsDialog(
                                          context, category.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showUpdateCategoryDialog(
                                          context, category.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, category.id);
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
                  Container(width: 200, height: 16, color: Colors.grey[300]),
                  Container(width: 200, height: 16, color: Colors.grey[300]),
                  Container(width: 100, height: 16, color: Colors.grey[300]),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Other helper methods (_showCategoryDetailsDialog, etc.) remain unchanged


  void _showCategoryDetailsDialog(BuildContext context, int categoryId) {
    _categoryController.getCategoryById(categoryId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_categoryController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = _categoryController.categoryDetails.value;
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
                    'Détails de la Catégorie',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF228D6D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller:
                        TextEditingController(text: details.designation),
                    decoration: const InputDecoration(labelText: 'Designation'),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller:
                        TextEditingController(text: details.description),
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
                      child: const Text('Fermer',style: TextStyle(color: Colors.white),),
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

  void _showUpdateCategoryDialog(BuildContext context, int categoryId) {
    _categoryController.getCategoryById(categoryId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_categoryController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = _categoryController.categoryDetails.value;
          if (details == null) return const SizedBox();

          final TextEditingController designationController =
              TextEditingController(text: details.designation);
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
                    'Modifier Catégorie',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF228D6D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: designationController,
                    decoration:
                        const InputDecoration(labelText: 'Designation*'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Description*'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _categoryController.updateCategory(
                            categoryId,
                            descriptionController.text,
                            designationController.text,
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Enregistrer',style:TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF228D6D),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Annuler'),
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

  void _showDeleteConfirmationDialog(BuildContext context, int categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content:
              const Text('Voulez-vous vraiment supprimer cette catégorie?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _categoryController.deleteCategory(categoryId);
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
