import 'package:flutter/material.dart';
import '../models/publication.dart';

class PublicationDetailScreen extends StatelessWidget {

  final Publication publication;

  const PublicationDetailScreen({
    super.key,
    required this.publication,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Publication Detail"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                publication.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Year: ${publication.publicationYear}",
              ),

              Text(
                "Citation: ${publication.citationCount}",
              ),

              Text(
                "Journal: ${publication.journalName}",
              ),

              Text(
                "DOI: ${publication.doi}",
              ),

              const SizedBox(height: 15),

              const Text(
                "Authors",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              ...publication.authors.map(
                (e) => Text(e),
              ),
            ],
          ),
        ),
      ),
    );
  }
}