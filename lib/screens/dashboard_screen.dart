import 'package:flutter/material.dart';
import '../models/publication.dart';

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
                Expanded(child: _buildSmallCard('Total Pubs', totalPublications.toString(), Icons.article, Colors.blue)),
                const SizedBox(width: 8),
                Expanded(child: _buildSmallCard('Avg Citations', averageCitations.toStringAsFixed(1), Icons.format_quote, Colors.orange)),
                const SizedBox(width: 8),
                Expanded(child: _buildSmallCard('Active Year', mostActiveYear > 0 ? mostActiveYear.toString() : 'N/A', Icons.calendar_today, Colors.green)),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Key Highlights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
            _buildWideCard('Top Journal', topJournal, Icons.library_books, Colors.purple),
            const SizedBox(height: 12),
            _buildWideCard('Top Author', topAuthor, Icons.person, Colors.indigo),
            const SizedBox(height: 12),
            _buildWideCard('Most Influential Paper', topPaper?.title ?? 'N/A', Icons.star, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(51),
          radius: 24,
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
