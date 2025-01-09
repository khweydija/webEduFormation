import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/Sidebar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:webpfe/controllers/StatisticController.dart'; // Update with your actual path

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final StatisticController _statisticController =
      Get.put(StatisticController());
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _statisticController
        .fetchStatistics(); // Fetch statistics when the page loads
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

      //backgroundColor: Color.fromARGB(255, 245, 244, 244),
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
  final StatisticController _statisticController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Color.fromARGB(255, 245, 244, 244),
      appBar: CustomAppBar(),
      body: Container(
        color: Colors.white,
        //color: Color.fromARGB(255, 245, 244, 244),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rapport Statistique',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF228D6D),
                  ),
                ),
                SizedBox(height: 20),
                Obx(() {
                  if (_statisticController.isLoading.value) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(5, (index) => shimmerCard()),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatisticCard(
                              icon: Icons.people_alt,
                              label: 'Total des Employés',
                              count: _statisticController.employeeCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 20), // Space between cards
                            _buildStatisticCard(
                              icon: Icons.school,
                              label: 'Total des Formateurs',
                              count: _statisticController.formateurCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 20), // Space between cards
                            _buildStatisticCard(
                              icon: Icons.category,
                              label: 'Total des Catégories',
                              count: _statisticController.categoryCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 20), // Space between cards
                            _buildStatisticCard(
                              icon: Icons.apartment,
                              label: 'Total des Départements',
                              count:
                                  _statisticController.departementCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 20), // Space between cards
                            _buildStatisticCard(
                              icon: Icons.star,
                              label: 'Total des Spécialités',
                              count: _statisticController.specialiteCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // Chart Widget
                      _buildBarChart(),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 200,
          height: 220,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 16),
              Container(
                height: 20,
                width: 60,
                color: Colors.grey[300],
              ),
              SizedBox(height: 8),
              Container(
                height: 14,
                width: 100,
                color: const Color.fromARGB(255, 243, 242, 242),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticCard({
    required IconData icon,
    required String label,
    required int count,
    required Color backgroundColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 200, // Fixed width
        height: 220, // Fixed height
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: backgroundColor,
              child: Icon(
                icon,
                size: 40,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Statistiques des Employés',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.5,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: _statisticController.employeeCount.value
                              .toDouble(),
                          color: Color.fromARGB(255, 45, 122, 106),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: _statisticController.formateurCount.value
                              .toDouble(),
                          color: Colors.green,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: _statisticController.categoryCount.value
                              .toDouble(),
                          color: Color.fromARGB(255, 156, 137, 108),
                        ),
                      ],
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
