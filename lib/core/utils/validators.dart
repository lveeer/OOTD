class AppValidators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidSmsCode(String code) {
    return code.length == 6 && RegExp(r'^\d{6}$').hasMatch(code);
  }

  static bool isValidUrl(String url) {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(url);
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱';
    }
    if (!isValidEmail(value)) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    if (!isValidPhone(value)) {
      return '请输入有效的手机号';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (!isValidPassword(value)) {
      return '密码长度不能少于6位';
    }
    return null;
  }

  static String? validateSmsCode(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入验证码';
    }
    if (!isValidSmsCode(value)) {
      return '请输入6位数字验证码';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '请输入$fieldName';
    }
    return null;
  }
}