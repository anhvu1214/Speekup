import 'dart:collection';

class SentenceFields {
  static final List<String> values = [id, word, isDownloaded, voiceFile, frequency, description];

  static final String id = 'id';
  static final String word = 'word';
  static final String isDownloaded = 'isDownloaded';
  static final String voiceFile = 'voiceFile';
  static final String frequency = 'frequency';
  static final String description = 'description';
}

class SentenceModel {
  final int? id;
  String word;
  bool isDownloaded;
  String voiceFile;
  int frequency;
  String description;

  SentenceModel({
    this.id,
    required this.word,
    required this.isDownloaded,
    required this.voiceFile,
    required this.frequency,
    required this.description,
  });

  SentenceModel copy({
    int? id, 
    String? word,
    bool? isDownloaded,
    String? voiceFile,
    int? frequency,
    String? description
    }) =>
      SentenceModel(
        id: id ?? this.id, 
        word: word ?? this.word,
        isDownloaded: isDownloaded ?? this.isDownloaded,
        voiceFile: voiceFile ?? this.voiceFile,
        frequency: frequency ?? this.frequency,
        description: description ?? this.description
        );

  static SentenceModel fromJson(Map<String, Object?> json) => SentenceModel(
      id: json[SentenceFields.id] as int?,
      word: json[SentenceFields.word] as String,
      isDownloaded: json[SentenceFields.isDownloaded] as bool,
      voiceFile: json[SentenceFields.voiceFile] as String,
      frequency: json[SentenceFields.frequency] as int,
      description: json[SentenceFields.description] as String
      );

  Map<String, Object?> toJson() =>
      {
        SentenceFields.id: id, 
        SentenceFields.word: word,
        SentenceFields.isDownloaded: isDownloaded,
        SentenceFields.voiceFile: voiceFile,
        SentenceFields.frequency: frequency,
        SentenceFields.description: description
        };
}
