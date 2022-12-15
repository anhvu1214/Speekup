import 'dart:collection';

class CategoryFields {
  static final List<String> values = [id, name, username, isDeletable];

  static final String id = 'id';
  static final String name = 'name';
  static final String isDeletable = 'isDeletable';
  static final String username = 'username';
}

class CategoryModel {
  final int? id;
  String name;
  int isDeletable;
  String username;

  CategoryModel({
    this.id,
    required this.name,
    required this.username,
    this.isDeletable = 1
  });

  CategoryModel copy({int? id, String? name, String? username, int? isDeletable}) => CategoryModel(
    id: id ?? this.id,
    name: name ?? this.name,
    username: username ?? this.username,
    isDeletable: isDeletable ?? this.isDeletable
  );

  static CategoryModel fromJson(Map<String, Object?> json) => CategoryModel(
    id: json[CategoryFields.id] as int?,
    name: json[CategoryFields.name] as String,
    username: json[CategoryFields.username] as String,
    isDeletable: json[CategoryFields.isDeletable] as int
  );

  Map<String, Object?> toJson() =>
      {CategoryFields.id: id, CategoryFields.name: name, CategoryFields.username: username, CategoryFields.isDeletable: isDeletable};
}
