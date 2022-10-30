class User {
  int? id;
  String password;
  String phone;
  String email;
  String fio;

  User({
    this.id,
    required this.password,
    required this.phone,
    required this.email,
    required this.fio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      password: json["password"],
      phone: json["phone"],
      email: json["email"],
      fio: json["fio"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "password": password,
      "phone": phone,
      "email": email,
      "fio": fio,
    };
  }

//

}
