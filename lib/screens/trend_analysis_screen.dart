import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/publication.dart';

class TrendAnalysisScreen extends StatelessWidget {
  final List<Publication> publications;

  const TrendAnalysisScreen({super.key, required this.publications});

  @override
  Widget build(BuildContext context) {
    Map<int, int> yearCounts = {};
    for (var p in publications) {
      if (p.publicationYear > 0) {
        yearCounts[p.publicationYear] = (yearCounts[p.publicationYear] ?? 0) + 1;
      }
    }

    if (yearCounts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trend Analysis')),
        body: const Center(child: Text('No publication data available.')),
      );
    }

    var sortedYears = yearCounts.keys.toList()..sort();
    double maxY = 0;
    
    List<BarChartGroupData> barGroups = [];
    for (var i = 0; i < sortedYears.length; i++) {
      int year = sortedYears[i];
      int count = yearCounts[year]!;
      if (count > maxY) maxY = count.toDouble();
      barGroups.add(
        BarChartGroupData(
          x: year,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.blueAccent,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            )
          ],
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trend Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Publications per Year',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY + (maxY * 0.2).ceilToDouble(),
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 == 0) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
