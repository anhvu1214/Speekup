import 'dart:collection';

class UserFields {
  static final List<String> values = [id, username, fullname, email, password];

  static final String id = 'id';
  static final String username = 'username';
  static final String fullname = 'fullname';
  static final String email = 'email';
  static final String password = 'password';
}

class UserModel {
  final int? id;
  String username;
  String fullname;
  String email;
  String password;

  UserModel({
    this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.password,
  });

  UserModel copy({
    int? id,
    String? username,
    String? fullname,
    String? email,
    String? password,
  }) =>
      UserModel(
          id: id ?? this.id,
          username: username ?? this.username,
          fullname: fullname ?? this.fullname,
          email: email ?? this.email,
          password: password ?? this.password);

  static UserModel fromJson(Map<String, Object?> json) => UserModel(
      id: json[UserFields.id] as int?,
      username: json[UserFields.username] as String,
      fullname: json[UserFields.fullname] as String,
      email: json[UserFields.email] as String,
      password: json[UserFields.password] as String);

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.username: username,
        UserFields.fullname: fullname,
        UserFields.email: email,
        UserFields.password: password
      };
}
