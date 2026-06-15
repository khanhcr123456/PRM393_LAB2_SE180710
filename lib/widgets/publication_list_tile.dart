import 'package:flutter/material.dart';
import '../models/publication.dart';
import '../screens/publication_detail_screen.dart';

class PublicationListTile extends StatelessWidget {
  final Publication paper;

  const PublicationListTile({super.key, required this.paper});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
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
        title: Text(paper.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "Year: ${paper.publicationYear}\nCitation: ${paper.citationCount}\nJournal: ${paper.journalName}",
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
