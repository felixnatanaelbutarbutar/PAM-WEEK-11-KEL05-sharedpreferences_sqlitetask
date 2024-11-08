class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime dateTime;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.dateTime,
  });

  // Tambahkan method copyWith
  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? dateTime,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}

class User {
  final int? id;
  final String username;
  final String password;

  User({
    this.id,
    required this.username,
    required this.password,
  });

  User copyWith({
    int? id,
    String? username,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}
