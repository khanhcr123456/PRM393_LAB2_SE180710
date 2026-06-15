import 'package:flutter/material.dart';
import '../models/publication.dart';
import '../widgets/small_stat_card.dart';
import '../widgets/wide_stat_card.dart';

class DashboardScreen extends StatelessWidget {
  final List<Publication> publications;
  final String topic;

  const DashboardScreen({super.key, required this.publications, required this.topic});

  @override
  Widget build(BuildContext context) {
    if (publications.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Research Dashboard')),
        body: const Center(child: Text('No data available to build dashboard.')),
      );
    }

    // 1. Total publications
    int totalPublications = publications.length;
    
    // 2. Average citation count
    int totalCitations = publications.fold(0, (sum, p) => sum + p.citationCount);
    double averageCitations = totalCitations / totalPublications;

    // 3. Most active publication year
    Map<int, int> yearCounts = {};
    for (var p in publications) {
      if (p.publicationYear > 0) {
        yearCounts[p.publicationYear] = (yearCounts[p.publicationYear] ?? 0) + 1;
      }
    }
    int mostActiveYear = 0;
    int maxYearCount = 0;
    yearCounts.forEach((year, count) {
      if (count > maxYearCount) {
        maxYearCount = count;
        mostActiveYear = year;
      }
    });

    // 4. Top journal
    Map<String, int> journalCounts = {};
    for (var p in publications) {
      String jName = p.journalName.trim();
      if (jName.isNotEmpty && jName != "Unknown Journal") {
        journalCounts[jName] = (journalCounts[jName] ?? 0) + 1;
      }
    }
    String topJournal = "N/A";
    int maxJournalCount = 0;
    journalCounts.forEach((journal, count) {
      if (count > maxJournalCount) {
        maxJournalCount = count;
        topJournal = journal;
      }
    });

    // 5. Top author
    Map<String, int> authorCounts = {};
    for (var p in publications) {
      for (var a in p.authors) {
        String aName = a.trim();
        if (aName.isNotEmpty) {
          authorCounts[aName] = (authorCounts[aName] ?? 0) + 1;
        }
      }
    }
    String topAuthor = "N/A";
    int maxAuthorCount = 0;
    authorCounts.forEach((author, count) {
      if (count > maxAuthorCount) {
        maxAuthorCount = count;
        topAuthor = author;
      }
    });

    // 6. Most influential paper
    Publication? topPaper;
    int maxCitation = -1;
    for (var p in publications) {
      if (p.citationCount > maxCitation) {
        maxCitation = p.citationCount;
        topPaper = p;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard: $topic'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: SmallStatCard(title: 'Total Pubs', value: totalPublications.toString(), icon: Icons.article, color: Colors.blue)),
                const SizedBox(width: 8),
                Expanded(child: SmallStatCard(title: 'Avg Citations', value: averageCitations.toStringAsFixed(1), icon: Icons.format_quote, color: Colors.orange)),
                const SizedBox(width: 8),
                Expanded(child: SmallStatCard(title: 'Active Year', value: mostActiveYear > 0 ? mostActiveYear.toString() : 'N/A', icon: Icons.calendar_today, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Key Highlights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
            WideStatCard(title: 'Top Journal', value: topJournal, icon: Icons.library_books, color: Colors.purple),
            const SizedBox(height: 12),
            WideStatCard(title: 'Top Author', value: topAuthor, icon: Icons.person, color: Colors.indigo),
            const SizedBox(height: 12),
            WideStatCard(title: 'Most Influential Paper', value: topPaper?.title ?? 'N/A', icon: Icons.star, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
