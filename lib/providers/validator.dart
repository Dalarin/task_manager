class Validator {
  static bool validateEmail(String email) {
    return RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool validatePhone(String phone) {
    return RegExp(r'^((\+7|7|8)+([0-9]){10})$').hasMatch(phone);
  }

  static bool validateUsername(String username) {
    return RegExp(r'^[A-ЯЁ][а-яё]+\s[A-ЯЁ][а-яё]+$').hasMatch(username);
  }
}