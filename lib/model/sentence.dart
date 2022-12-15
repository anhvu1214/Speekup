import 'dart:collection';

class SentenceFields {
  static final List<String> values = [id, word, isDeletable, frequency, description];

  static final String id = 'id';
  static final String word = 'word';
  static final String isDeletable = 'isDeletable';
  static final String frequency = 'frequency';
  static final String description = 'description';
}

class SentenceModel {
  final int? id;
  String word;
  int isDeletable;
  int frequency;
  String? description;

  SentenceModel({
    this.id,
    required this.word,
    this.isDeletable = 1,
    this.frequency = 0,
    this.description
  });

  SentenceModel copy({
    int? id, 
    String? word,
    int? isDeletable,
    int? frequency,
    String? description
    }) =>
      SentenceModel(
        id: id ?? this.id, 
        word: word ?? this.word,
        isDeletable: isDeletable ?? this.isDeletable,
        frequency: frequency ?? this.frequency,
        description: description ?? this.description
        );

  static SentenceModel fromJson(Map<String, Object?> json) => SentenceModel(
      id: json[SentenceFields.id] as int?,
      word: json[SentenceFields.word] as String,
      isDeletable: json[SentenceFields.isDeletable] as int,
      frequency: json[SentenceFields.frequency] as int,
      description: json[SentenceFields.description] as String?
      );

  Map<String, Object?> toJson() =>
      {
        SentenceFields.id: id, 
        SentenceFields.word: word,
        SentenceFields.isDeletable: isDeletable,
        SentenceFields.frequency: frequency,
        SentenceFields.description: description
        };
}
