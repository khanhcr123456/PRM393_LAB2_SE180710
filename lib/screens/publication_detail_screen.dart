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
        title: const Text(
          "Publication Detail",
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              publication.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Publication Year: ${publication.publicationYear}",
            ),

            const SizedBox(height: 8),

            Text(
              "Journal: ${publication.journalName}",
            ),

            const SizedBox(height: 8),

            Text(
              "Citation Count: ${publication.citationCount}",
            ),

            const SizedBox(height: 8),

            Text(
              "DOI: ${publication.doi}",
            ),

            const SizedBox(height: 20),

            const Text(
              "Authors",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            ...publication.authors.map(
              (author) => Padding(
                padding:
                    const EdgeInsets.only(
                        bottom: 5),
                child: Text(author),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Abstract",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              publication.abstractText,
            ),
          ],
        ),
      ),
    );
  }
}