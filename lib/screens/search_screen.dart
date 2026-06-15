import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/publication_provider.dart';
import '../widgets/publication_list_tile.dart';
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

  final TextEditingController controller = TextEditingController();
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _performSearch() {
    FocusScope.of(context).unfocus();
    context.read<PublicationProvider>().search(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PublicationProvider>();
    final publications = provider.publications;

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
              onSubmitted: (_) => _performSearch(),
              decoration: const InputDecoration(
                labelText: "Research Topic",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _performSearch,
              child: const Text("Search"),
            ),

            const SizedBox(height: 10),

            if (provider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

            if (provider.isLoading)
              const CircularProgressIndicator(),

            Expanded(
              child: ListView.builder(
                itemCount:
                    publications.length,

                itemBuilder:
                    (context, index) {

                  final paper = publications[index];
                  return PublicationListTile(paper: paper);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}