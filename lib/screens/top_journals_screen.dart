import 'package:flutter/material.dart';
import '../models/publication.dart';

class TopJournalsScreen extends StatelessWidget {
  final List<Publication> publications;

  const TopJournalsScreen({super.key, required this.publications});

  @override
  Widget build(BuildContext context) {
    // Group and count publications by journal
    Map<String, int> journalCounts = {};
    for (var p in publications) {
      String name = p.journalName.trim();
      if (name.isEmpty) {
        name = "Unknown Journal";
      }
      journalCounts[name] = (journalCounts[name] ?? 0) + 1;
    }

    // Sort journals by count (descending)
    var sortedJournals = journalCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Research Journals'),
      ),
      body: sortedJournals.isEmpty
          ? const Center(child: Text('No journal data available.'))
          : ListView.builder(
              itemCount: sortedJournals.length,
              itemBuilder: (context, index) {
                final entry = sortedJournals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    title: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${entry.value} papers',
                        style: TextStyle(
                          color: Colors.teal.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
