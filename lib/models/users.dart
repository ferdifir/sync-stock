class Users {
  int id;
  String username;
  String password;
  String fullName;
  String email;
  String phoneNumber;
  String level;
  String block;
  String sessionId;

  Users({
    required this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.level,
    required this.block,
    required this.sessionId,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      fullName: json['nama_lengkap'],
      email: json['email'],
      phoneNumber: json['no_telp'],
      level: json['level'],
      block: json['blokir'],
      sessionId: json['id_session'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'nama_lengkap': fullName,
      'email': email,
      'no_telp': phoneNumber,
      'level': level,
      'blokir': block,
      'id_session': sessionId,
    };
  }
}
