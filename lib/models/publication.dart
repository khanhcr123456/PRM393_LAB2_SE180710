class Publication {
  final String title;
  final int publicationYear;
  final int citationCount;
  final String journalName;
  final String doi;
  final List<String> authors;

  Publication({
    required this.title,
    required this.publicationYear,
    required this.citationCount,
    required this.journalName,
    required this.doi,
    required this.authors,
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
     List<String> authors = [];

    if (json["authorships"] != null) {
      authors = (json["authorships"] as List)
          .map<String>(
            (e) => (e["author"]?["display_name"] ?? "").toString()
          )
          .toList();
    }

    return Publication(
      title: json["title"] ?? "",
      publicationYear: json["publication_year"] ?? 0,
      citationCount: json["cited_by_count"] ?? 0,
      journalName:
          json["primary_location"]?["source"]
                  ?["display_name"] ??
              "",
      doi: json["doi"] ?? "",
      authors: authors,
    );
  }
}