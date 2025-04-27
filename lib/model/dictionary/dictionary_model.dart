class DictionaryModel {
  final List<DictionaryEntry> entries;

  DictionaryModel({required this.entries});

  factory DictionaryModel.fromJson(List<dynamic> json) {
    return DictionaryModel(
      entries: json.map((entry) => DictionaryEntry.fromJson(entry)).toList(),
    );
  }
}

class DictionaryEntry {
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;

  DictionaryEntry({
    required this.word,
    this.phonetic,
    required this.phonetics,
    required this.meanings,
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    return DictionaryEntry(
      word: json['word'] ?? '', // Handle null word
      phonetic: json['phonetic'],
      phonetics: (json['phonetics'] as List<dynamic>?)
          ?.map((p) => Phonetic.fromJson(p))
          .toList() ?? [],
      meanings: (json['meanings'] as List<dynamic>?)
          ?.map((m) => Meaning.fromJson(m))
          .toList() ?? [],
    );
  }
}

class Phonetic {
  final String text;
  final String audio;

  Phonetic({
    required this.text,
    required this.audio,
  });

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'] ?? '', // Handle null text
      audio: json['audio'] ?? '', // Handle null audio
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] ?? '', // Handle null partOfSpeech
      definitions: (json['definitions'] as List<dynamic>?)
          ?.map((d) => Definition.fromJson(d))
          .toList() ?? [],
    );
  }
}

class Definition {
  final String definition;
  final String? example;

  Definition({
    required this.definition,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] ?? '', // Handle null definition
      example: json['example'],
    );
  }
}