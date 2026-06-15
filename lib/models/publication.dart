class Publication {
  final String title;
  final int publicationYear;
  final int citationCount;
  final String journalName;
  final String doi;
  final String abstractText;
  final List<String> authors;

  Publication({
    required this.title,
    required this.publicationYear,
    required this.citationCount,
    required this.journalName,
    required this.doi,
    required this.abstractText,
    required this.authors,
  });

static String reconstructAbstract(
    Map<String, dynamic>? abstractIndex) {

  if (abstractIndex == null) {
    return "Abstract unavailable";
  }

  List<MapEntry<String, int>> words = [];

  abstractIndex.forEach((word, positions) {

    for (var pos in positions) {

      words.add(
        MapEntry(word, pos),
      );
    }

  });

  words.sort(
    (a, b) => a.value.compareTo(b.value),
  );

  return words
      .map((e) => e.key)
      .join(" ");
}

  factory Publication.fromJson(Map<String, dynamic> json) {
    List<String> authors = [];

    final authorships = json["authorships"];

    if (authorships != null && authorships is List) {
      authors = authorships
          .map<String>((authorShip) {
            if (authorShip is Map<String, dynamic>) {
              final author = authorShip["author"];

              if (author is Map<String, dynamic>) {
                return author["display_name"]?.toString() ?? "";
              }
            }

            return "";
          })
          .where((name) => name.isNotEmpty)
          .toList();
    }

    return Publication(
       title: json["title"] ?? "",
    publicationYear:
        json["publication_year"] ?? 0,
    citationCount:
        json["cited_by_count"] ?? 0,
    journalName:
        json["primary_location"]?["source"]
                ?["display_name"] ??
            "Unknown Journal",
    doi: json["doi"] ?? "",
    abstractText: reconstructAbstract(
      json["abstract_inverted_index"],
    ),
    authors: authors,
    );
  }
}