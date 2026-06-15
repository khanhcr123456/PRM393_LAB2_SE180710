import 'dart:async';
import 'package:flutter/material.dart';
import '../models/publication.dart';
import '../services/openalex_service.dart';
import 'publication_detail_screen.dart';
import 'trend_analysis_screen.dart';
import 'influential_papers_screen.dart';
import 'top_journals_screen.dart';
import 'top_authors_screen.dart';
import 'dashboard_screen.dart';

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
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  Future<void> search() async {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      publications = []; // Xóa kết quả cũ để ẩn nút và danh sách
    });

    try {

      final result =
          await service.searchPublications(
              controller.text);

      setState(() {
        publications = result;
      });

    } catch (e) {
      if (!mounted) return;
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
        actions: [
          if (publications.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.dashboard),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DashboardScreen(
                      publications: publications,
                      topic: controller.text.trim(),
                    ),
                  ),
                );
              },
              tooltip: 'Dashboard',
            ),
            IconButton(
              icon: const Icon(Icons.star),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InfluentialPapersScreen(
                      publications: publications,
                    ),
                  ),
                );
              },
              tooltip: 'Top Influential Papers',
            ),
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TopAuthorsScreen(
                      publications: publications,
                    ),
                  ),
                );
              },
              tooltip: 'Top Contributing Authors',
            ),
            IconButton(
              icon: const Icon(Icons.library_books),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TopJournalsScreen(
                      publications: publications,
                    ),
                  ),
                );
              },
              tooltip: 'Top Research Journals',
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrendAnalysisScreen(
                      publications: publications,
                    ),
                  ),
                );
              },
              tooltip: 'Trend Analysis',
            ),
          ]
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller: controller,
              onSubmitted: (_) => search(),
              decoration: const InputDecoration(
                labelText: "Research Topic",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
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
                      title:
                          Text(paper.title),

                      subtitle: Text(
                        "Year: ${paper.publicationYear}\n"
                        "Citation: ${paper.citationCount}\n"
                        "Journal: ${paper.journalName}",
                      ),
                        trailing: const Icon(
                        Icons.arrow_forward_ios,
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