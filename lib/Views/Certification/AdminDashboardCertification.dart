import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/Certification/CertificateScreen.dart';
import 'package:webpfe/Views/Certification/SearchAndAddCertification.dart';
import 'package:printing/printing.dart';

import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/controllers/certificationController.dart';
import 'package:webpfe/models/Certification.dart';

import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class AdminDashboardCertification extends StatefulWidget {
  @override
  _AdminDashboardCertificationState createState() =>
      _AdminDashboardCertificationState();
}

class _AdminDashboardCertificationState
    extends State<AdminDashboardCertification> {
  final CertificationController _certificationController =
      Get.find();
  int selectedIndex = 6;

  @override
  void initState() {
    super.initState();
    _certificationController.fetchCertifications();
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
                child: MainCertificationContent(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MainCertificationContent extends StatelessWidget {
  final CertificationController _certificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        color: Colors.white,
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
                      'Certifications',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF228D6D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ///////////////////////////////////////////////////////////
                ////////////////////////////////////////////////////////////////////////////////////////////////////
                SearchAndAddCertification(), // Adjust if needed
                ////////////////////////////////
                ////////////////////////////
                const SizedBox(height: 20),
                Obx(() {
                  if (_certificationController.isLoading.value) {
                    return shimmerTable();
                  } else if (_certificationController.certifications.isEmpty) {
                    return const Center(child: Text('No certifications found'));
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
                            DataColumn(label: Text('Title')),
                            DataColumn(label: Text('Notes')),
                            DataColumn(label: Text('Employees')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: _certificationController.certifications
                              .map((certification) {
                            return DataRow(cells: [
                              DataCell(Text(certification.titre)),
                              DataCell(Text(certification.notes)),
                              DataCell(Text(certification.employe.nom)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showCertificationDetailsDialog(
                                          context, certification.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showUpdateCertificationDialog(
                                          context, certification.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _showDeleteCertificationDialog(
                                          context, certification.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.print,
                                        color: Color(0xFF00352C)),
                                    onPressed: () {
                                      _printCertification(certification);
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
                  Container(
                    width: 100,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  Container(
                    width: 200,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  Container(
                    width: 80,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showCertificationDetailsDialog(
      BuildContext context, int certificationId) {
    _certificationController.getCertificationById(certificationId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (_certificationController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = _certificationController.certificationDetails.value;
          if (details == null) return const SizedBox();

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: 900,
              height: 700,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade100, width: 2),
              ),
              child: Stack(
                children: [
                  // Watermark or background logo
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(Icons.school, size: 300, color: Colors.blue),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/logoSMART.png', // Replace with your logo path
                            width: 200,
                            height: 150,
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Certificate Title
                      Text(
                        details.titre.toUpperCase(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Subheading
                      Text(
                        'ATTESTATION DE RÉUSSITE',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Recipient Name
                      const Text(
                        'CECI EST DÉCERNÉ À',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            details.employe.nom, // Dynamic employee name
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            details.employe.prenom, // Dynamic employee name
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      // Certificate Body Text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Pour avoir brillamment réussi la formation organisée par SMART MS dans le domaine du développement Front-end avec le framework ${details.formation.titre} Ce certificat atteste que ${details.employe.nom} a démontré un niveau élevé de compréhension et d'assimilation des concepts enseignés",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Signature
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Nevissa Iyoh',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Responsable Unité Développement',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
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

/////////////////////////////////////////////////impriment
  void _printCertification(Certification certification) async {
    final doc = pw.Document();

    // Load the logo image as Uint8List
    final Uint8List logoData =
        await imageFromAssetBundle('assets/images/logoSMART.png');

    // Load a replacement for the watermark (e.g., an icon image)
    final Uint8List watermarkData = await imageFromAssetBundle(
        'assets/images/school.png'); // Replace with your watermark image path

    // Define a custom page size (900x700 in points)
    final PdfPageFormat customPageFormat = PdfPageFormat(900, 700);

    doc.addPage(
      pw.Page(
        pageFormat: customPageFormat,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              gradient: pw.LinearGradient(
                colors: [
                  PdfColor.fromHex('#FFFFFF'),
                  PdfColor.fromHex('#E3F2FD'),
                ],
                begin: pw.Alignment.topCenter,
                end: pw.Alignment.bottomCenter,
              ),
              border:
                  pw.Border.all(color: PdfColor.fromHex('#BBDEFB'), width: 2),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Stack(
              children: [
                // Watermark or background logo
                pw.Positioned(
                  top: 100,
                  right: 100,
                  child: pw.Opacity(
                    opacity: 0.1,
                    child: pw.Image(
                      pw.MemoryImage(watermarkData), // Use the watermark image
                      width: 300,
                      height: 200,
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Top Logo
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Image(
                          pw.MemoryImage(logoData),
                          width: 100,
                          height: 80,
                        ),
                      ],
                    ),
                    pw.Spacer(),
                    // Certificate Title
                    pw.Center(
                      child: pw.Text(
                        certification.titre.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#0D47A1'),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    // Subheading
                    pw.Center(
                      child: pw.Text(
                        'ATTESTATION DE RÉUSSITE',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontStyle: pw.FontStyle.italic,
                          color: PdfColor.fromHex('#1976D2'),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 30),
                    // Recipient Section
                    pw.Center(
                      child: pw.Text(
                        'CECI EST DÉCERNÉ À',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#757575'),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Center(
                      child: pw.Text(
                        '${certification.employe.nom} ${certification.employe.prenom}',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#000000'),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    // Certificate Body Text
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 40),
                      child: pw.Text(
                        "Pour avoir brillamment réussi la formation organisée par SMART MS dans le domaine du développement Front-end avec le framework ${certification.formation.titre}. Ce certificat atteste que ${certification.employe.nom} a démontré un niveau élevé de compréhension et d'assimilation des concepts enseignés.",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColor.fromHex('#616161'),
                        ),
                      ),
                    ),
                    pw.Spacer(),
                    // Signature Section
                    pw.Align(
                      alignment: pw.Alignment.bottomRight,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Nevissa Iyoh',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Responsable Unité Développement',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontStyle: pw.FontStyle.italic,
                              color: PdfColor.fromHex('#757575'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

// Helper function to load the image as Uint8List
  Future<Uint8List> imageFromAssetBundle(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  //////////////////////////////////////////////////

  void _showUpdateCertificationDialog(
      BuildContext context, int certificationId) {
    _certificationController.getCertificationById(certificationId);
    // Similar to `_showUpdateDepartementDialog`
  }

  void _showDeleteCertificationDialog(
      BuildContext context, int certificationId) {
    // Similar to `_showDeleteConfirmationDialog`
  }
}
