class WordDefinition {
  final String word;
  final List<String> meanings;

  WordDefinition({
    required this.word,
    required this.meanings,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> json) {
    final List<dynamic> anlamlarListe = json['anlamlarListe'] ?? [];
    final List<String> meanings = anlamlarListe.map<String>((anlam) => anlam['anlam'] as String).toList();

    return WordDefinition(
      word: json['madde'] as String,
      meanings: meanings,
    );
  }

  factory WordDefinition.empty() {
    return WordDefinition(word: '', meanings: []);
  }
}
