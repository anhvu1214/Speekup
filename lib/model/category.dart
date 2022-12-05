import 'dart:collection';

class CategoryFields {
  static final List<String> values = [id, name];

  static final String id = 'id';
  static final String name = 'name';
  static final String userId = 'categoryId';
}

class CategoryModel {
  final int? id;
  String name;
  int? userID;

  CategoryModel({
    this.id,
    required this.name,
    this.userID = 0,
  });

  CategoryModel copy({int? id, String? name, int? userID}) => CategoryModel(
    id: id ?? this.id,
    name: name ?? this.name,
    userID: userID ?? this.userID
  );

  static CategoryModel fromJson(Map<String, Object?> json) => CategoryModel(
    id: json[CategoryFields.id] as int?,
    name: json[CategoryFields.name] as String,
    userID: json[CategoryFields.userId] as int?
  );

  Map<String, Object?> toJson() =>
      {CategoryFields.id: id, CategoryFields.name: name, CategoryFields.userId: userID};
}
