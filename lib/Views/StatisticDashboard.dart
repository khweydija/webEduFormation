import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'package:webpfe/Views/AppBar.dart';
import 'package:webpfe/Views/Sidebar.dart';
import 'package:webpfe/controllers/StatisticController.dart';
import 'package:fl_chart/fl_chart.dart' as fl_chart;
import 'package:pie_chart/pie_chart.dart' as pie_chart;

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
    _statisticController.fetchStatistics();
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rapport Statistique'.tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF228D6D),
                  ),
                ),
                SizedBox(height: 20),
                Obx(() {
                  if (_statisticController.isLoading.value) {
                    // Shimmer effect while loading
                    return Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              6,
                              (index) => Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: _buildShimmerCard(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 250,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
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
                              label: 'Total des Employés'.tr,
                              count: _statisticController.employeeCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 16),
                            _buildStatisticCard(
                              icon: Icons.school,
                              label: 'Total des Formateurs'.tr,
                              count: _statisticController.formateurCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 16),
                            _buildStatisticCard(
                              icon: Icons.category,
                              label: 'Total des Catégories'.tr,
                              count: _statisticController.categoryCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 16),
                            _buildStatisticCard(
                              icon: Icons.apartment,
                              label: 'Total des Départements'.tr,
                              count:
                                  _statisticController.departementCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 16),
                            _buildStatisticCard(
                              icon: Icons.star,
                              label: 'Total des Spécialités'.tr,
                              count: _statisticController.specialiteCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                            SizedBox(width: 16),
                            _buildStatisticCard(
                              icon: Icons.verified,
                              label: 'Total des Certifications'.tr,
                              count:
                                  _statisticController.certificationCount.value,
                              backgroundColor:
                                  Color.fromARGB(255, 241, 241, 239),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),

                      // Graphs
                      Text(
                        'Visualisation Statistique'.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF228D6D),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Bar Chart
                          Flexible(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Align the text to the start
                                  children: [
                                    // Title for the Bar Chart
                                    Center(
                                      child: Text(
                                        'Nombre de Formations par mois'.tr,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF228D6D),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            10), // Add some spacing between title and chart
                                    Container(
                                      height: 250,
                                      child: Obx(() {
                                        final data = _statisticController
                                            .planificationsCountByMonth;
                                        if (data.isEmpty) {
                                          return Center(
                                            child: Text(
                                                'No data available for the chart'),
                                          );
                                        }

                                        return BarChart(
                                          BarChartData(
                                            alignment:
                                                BarChartAlignment.spaceAround,
                                            maxY: (data.values.reduce((a, b) =>
                                                        a > b ? a : b) *
                                                    1.2)
                                                .ceilToDouble(),
                                            barGroups:
                                                data.entries.map((entry) {
                                              return BarChartGroupData(
                                                x: entry.key,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: entry.value.toDouble(),
                                                    color: Colors.teal,
                                                    width: 10,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                            titlesData: FlTitlesData(
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 32,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    if (value % 1 == 0) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 8.0),
                                                        child: Text(
                                                          value
                                                              .toInt()
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      );
                                                    }
                                                    return SizedBox.shrink();
                                                  },
                                                ),
                                              ),
                                              rightTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  getTitlesWidget:
                                                      (value, meta) {
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
                                                    if (monthNames.containsKey(
                                                        value.toInt())) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Text(
                                                          monthNames[
                                                              value.toInt()]!,
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      );
                                                    }
                                                    return SizedBox.shrink();
                                                  },
                                                ),
                                              ),
                                            ),
                                            gridData: FlGridData(
                                              show: true,
                                              drawHorizontalLine: true,
                                              getDrawingHorizontalLine:
                                                  (value) {
                                                if (value % 1 == 0) {
                                                  return FlLine(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    strokeWidth: 1,
                                                  );
                                                }
                                                return FlLine(
                                                    color: Colors.transparent);
                                              },
                                              drawVerticalLine: false,
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 16),

                          // Doughnut Chart
                          Flexible(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                  height: 250,
                                  child: pie_chart.PieChart(
                                    dataMap: {
                                      "Formations en cours".tr: 30,
                                      "Formations en retard".tr: 30,
                                      "Formations Completés".tr: 40,
                                    },
                                    chartType: pie_chart.ChartType.ring,
                                    ringStrokeWidth: 15,
                                    colorList: [
                                      Colors.pinkAccent,
                                      Colors.blueAccent,
                                      Colors.greenAccent,
                                    ],
                                    chartValuesOptions:
                                        pie_chart.ChartValuesOptions(
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: true,
                                      chartValueStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    legendOptions: pie_chart.LegendOptions(
                                      showLegends: true,
                                      legendPosition:
                                          pie_chart.LegendPosition.bottom,
                                      legendTextStyle: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
        width: 160,
        height: 180,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: backgroundColor,
              child: Icon(
                icon,
                size: 30,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 160,
        height: 180,
        padding: EdgeInsets.all(12),
        color: Colors.grey.shade300,
      ),
    );
  }
}
