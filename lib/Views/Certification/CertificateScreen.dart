import 'package:flutter/material.dart';

class CertificateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 900,
          height: 700,
          padding: EdgeInsets.all(20),
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
                        width: 200,
                        height: 150,

                        'assets/images/logoSMART.png', // Replace with your logo path
                      ),
                    ],
                  ),

                  Spacer(),

                  // Certificate Title
                  Text(
                    'BACK-END SPRING BOOT',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Subheading
                  Text(
                    'ATTESTATION DE RÉUSSITE',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Recipient Name
                  Text(
                    'CECI EST DÉCERNÉ À',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Teslem Filali', // Replace with the name dynamically
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Certificate Body Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Pour avoir brillamment réussi la formation organisée par SMART MS dans le domaine du développement Back-end avec le framework Spring Boot. Ce certificat atteste que Teslem Filali a démontré un niveau élevé de compréhension et d'assimilation des concepts enseignés.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  Spacer(),

                  // Signature
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
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
      ),
    );
  }
}
