import 'package:flutter/material.dart';
import '../models/publication.dart';
import 'publication_detail_screen.dart';

class InfluentialPapersScreen extends StatelessWidget {
  final List<Publication> publications;

  const InfluentialPapersScreen({super.key, required this.publications});

  @override
  Widget build(BuildContext context) {
    // Sort publications by citation count (highest to lowest)
    final sortedPublications = List<Publication>.from(publications)
      ..sort((a, b) => b.citationCount.compareTo(a.citationCount));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Influential Papers'),
      ),
      body: ListView.builder(
        itemCount: sortedPublications.length,
        itemBuilder: (context, index) {
          final paper = sortedPublications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(
                  '#${index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              title: Text(paper.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                "Citations: ${paper.citationCount}\nYear: ${paper.publicationYear}\nJournal: ${paper.journalName}",
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PublicationDetailScreen(
                      publication: paper,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
