import 'package:flutter/material.dart';
import '../models/publication.dart';
import '../services/openalex_service.dart';
import 'publication_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {

  final TextEditingController controller =
      TextEditingController();

  final OpenAlexService service =
      OpenAlexService();

  List<Publication> publications = [];

  bool isLoading = false;

  Future<void> search() async {

    setState(() {
      isLoading = true;
    });

    try {

      final result =
          await service.searchPublications(
              controller.text);

      setState(() {
        publications = result;
      });

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Journal Trend Analyzer",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller: controller,
              decoration:
                  const InputDecoration(
                labelText:
                    "Research Topic",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: search,
              child: const Text(
                "Search",
              ),
            ),

            const SizedBox(height: 10),

            if (isLoading)
              const CircularProgressIndicator(),

            Expanded(
              child: ListView.builder(
                itemCount:
                    publications.length,

                itemBuilder:
                    (context, index) {

                  final paper =
                      publications[index];

                  return Card(

                    child: ListTile(

                      title:
                          Text(paper.title),

                      subtitle: Text(
                        "Year: ${paper.publicationYear}\n"
                        "Citation: ${paper.citationCount}\n"
                        "Journal: ${paper.journalName}",
                      ),

                    ),

                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}