import 'package:flutter/material.dart';
import '../models/publication.dart';

class TopAuthorsScreen extends StatelessWidget {
  final List<Publication> publications;

  const TopAuthorsScreen({super.key, required this.publications});

  @override
  Widget build(BuildContext context) {
    // Group and count publications by author
    Map<String, int> authorCounts = {};
    for (var p in publications) {
      for (var author in p.authors) {
        String name = author.trim();
        if (name.isNotEmpty) {
          authorCounts[name] = (authorCounts[name] ?? 0) + 1;
        }
      }
    }

    // Sort authors by count (descending)
    var sortedAuthors = authorCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Contributing Authors'),
      ),
      body: sortedAuthors.isEmpty
          ? const Center(child: Text('No author data available.'))
          : ListView.builder(
              itemCount: sortedAuthors.length,
              itemBuilder: (context, index) {
                final entry = sortedAuthors[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${entry.value} papers',
                        style: TextStyle(
                          color: Colors.indigo.shade900,
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
