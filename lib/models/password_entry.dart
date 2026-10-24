class PasswordEntry {
  final int? id;
  final String title;
  final String username;
  final String encryptedPassword;
  final String iv; // Initialization Vector for AES

  PasswordEntry({
    this.id,
    required this.title,
    required this.username,
    required this.encryptedPassword,
    required this.iv,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'encryptedPassword': encryptedPassword,
      'iv': iv,
    };
  }

  factory PasswordEntry.fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'] as int?,
      title: map['title'] as String,
      username: map['username'] as String,
      encryptedPassword: map['encryptedPassword'] as String,
      iv: map['iv'] as String,
    );
  }
}