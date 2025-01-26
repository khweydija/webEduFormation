import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/controllers/StatisticController.dart';

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
      appBar: CustomAppBar(),
      body: Container(
        color: Colors.white,
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
                    return Center(child: CircularProgressIndicator());
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
                            SizedBox(width: 20),
                            _buildStatisticCard(
                              icon: Icons.school,
                              label: 'Total des Formateurs',
                              count: _statisticController.formateurCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 20),
                            _buildStatisticCard(
                              icon: Icons.category,
                              label: 'Total des Catégories',
                              count: _statisticController.categoryCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 20),
                            _buildStatisticCard(
                              icon: Icons.apartment,
                              label: 'Total des Départements',
                              count:
                                  _statisticController.departementCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 20),
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

                      // Add Bar Chart in a Card
                      Text(
                        'Planifications par Mois',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF228D6D),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.8, // Reduce the width
                            height: 300, // Set a fixed height
                            child: Obx(() {
                              final data = _statisticController
                                  .planificationsCountByMonth;
                              if (data.isEmpty) {
                                return Center(
                                  child:
                                      Text('No data available for the chart'),
                                );
                              }

                              return BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: (data.values
                                              .reduce((a, b) => a > b ? a : b) *
                                          1.2)
                                      .toDouble(),
                                  barGroups: data.entries.map((entry) {
                                    return BarChartGroupData(
                                      x: entry.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value.toDouble(),
                                          color: Colors.teal,
                                          width: 15,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        )
                                      ],
                                    );
                                  }).toList(),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          // Display only integer values
                                          if (value % 1 == 0) {
                                            // Check if the value is an integer
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                value
                                                    .toInt()
                                                    .toString(), // Convert to integer for display
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            );
                                          }
                                          return SizedBox
                                              .shrink(); // Hide non-integer values
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          const monthNames = {
                                            1: 'Jan',
                                            2: 'Feb',
                                            3: 'Mar',
                                            4: 'Apr',
                                            5: 'May',
                                            6: 'Jun',
                                            7: 'Jul',
                                            8: 'Aug',
                                            9: 'Sep',
                                            10: 'Oct',
                                            11: 'Nov',
                                            12: 'Dec',
                                          };
                                          if (monthNames
                                              .containsKey(value.toInt())) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                monthNames[value.toInt()]!,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                  ),
                                  gridData: FlGridData(show: true),
                                  borderData: FlBorderData(show: false),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
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
        width: 200,
        height: 220,
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
}
