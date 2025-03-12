class AppTextFieldValidator {
  static String? requiredValidator(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return '* Wajib diisi';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ' Wajib diisi';
    }

    bool isValidEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!isValidEmail) {
      return 'Incorrect email format';
    }
    return null;
  }

  static String? passwordValidator(String value) {
    if (value.isEmpty) {
      return ' Wajib diisi';
    }

    RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$');
    if (!regex.hasMatch(value)) {
      return 'Password must be 8-16 characters, contain 1 uppercase, 1 lowercase, and 1 numeric';
    }
    return null;
  }

  static String? passwordConfirmValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return ' Wajib diisi';
    }

    RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$');
    if (!regex.hasMatch(value)) {
      return 'Password must be 8-16 characters, contain 1 uppercase, 1 lowercase, and 1 numeric';
    }

    if (value != password) {
      return 'Passwords did not match';
    }
    return null;
  }

  static String? numberOnlyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please fill out this field';
    }
    if (value.trim().isEmpty) {
      return '* Please fill out this field';
    }

    RegExp regex = RegExp(r'\d');
    if (!regex.hasMatch(value)) {
      return '* Password must be numeric';
    }
    return null;
  }
}
