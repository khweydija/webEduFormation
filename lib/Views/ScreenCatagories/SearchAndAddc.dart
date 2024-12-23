import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/controllers/catagoriesController.dart';


class SearchAndAddc extends StatefulWidget {
  @override
  _SearchAndAddState createState() => _SearchAndAddState();
}

class _SearchAndAddState extends State<SearchAndAddc> {
  final CategoryController _categorieController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Search categories
  void _searchCategories() async {
    if (_searchController.text.isNotEmpty) {
      await _categorieController.searchCategories(_searchController.text);
    } else {
      _categorieController.fetchCategories();
    }
  }

  // Open dialog to create a category
  void _showCreateCategoryDialog() {
    _descriptionController.clear();
    _designationController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Create Category',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _designationController,
                      decoration: const InputDecoration(
                        labelText: 'Designation*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the designation';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _submitCreateCategory,
                          child: const Text('Create', style: TextStyle(color: Colors.white)),
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
            ),
          ),
        );
      },
    );
  }

  // Submit the create category form
  void _submitCreateCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _categorieController.createCategory(
          _descriptionController.text,
          _designationController.text,
        );
        Navigator.of(context).pop(); // Close dialog on success
        Get.snackbar('Success', 'Category created successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to create category');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: constraints.maxWidth > 800 ? 700 : constraints.maxWidth * 0.7,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.black54),
                    onPressed: _searchCategories,
                  ),
                  hintText: 'Search categories...',
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showCreateCategoryDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Category', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF228D6D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
