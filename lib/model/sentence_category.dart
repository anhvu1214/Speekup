// import 'dart:collection';

// class SentenceFields {
//   static final List<String> values = [id, userID, categoryID];

//   static final String id = 'id';
//   static final String userID = 'userID';
//   static final String categoryID = 'categoryID';
// }

// class SentenceModel {
//   final int? id;
//   int userID;
//   int categoryID;

//   SentenceModel({
//     this.id,
//     required this.userID,
//     required this.categoryID,
//   });

//   SentenceModel copy({
//     int? id, 
//     int? userID,
//     int? categoryID,
//     }) =>
//       SentenceModel(
//         id: id ?? this.id, 
//         userID: userID ?? this.userID,
//         categoryID: categoryID ?? this.categoryID,
//         );

//   static SentenceModel fromJson(Map<String, Object?> json) => SentenceModel(
//       id: json[SentenceFields.id] as int?,
//       userID: json[SentenceFields.userID] as int,
//       categoryID: json[SentenceFields.categoryID] as int,
//       );

//   Map<String, Object?> toJson() =>
//       {
//         SentenceFields.id: id, 
//         SentenceFields.userID: userID,
//         SentenceFields.categoryID: categoryID
//         };
// }
