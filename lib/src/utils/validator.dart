class Validator {
  static bool validateMail(String mail) {
    /*String pattern =
        r'(^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$)';*/
    /*String pattern =
        r'(^$?\-?([1-9]{1}[0-9]{0,2}(\,\d{3})*(\.\d{0,2})?|[1-9]{1}\d{0,}(\.\d{0,2})?|0(\.\d{0,2})?|(\.\d{1,2}))$|^\-?$?([1-9]{1}\d{0,2}(\,\d{3})*(\.\d{0,2})?|[1-9]{1}\d{0,}(\.\d{0,2})?|0(\.\d{0,2})?|(\.\d{1,2}))$|^\($?([1-9]{1}\d{0,2}(\,\d{3})*(\.\d{0,2})?|[1-9]{1}\d{0,}(\.\d{0,2})?|0(\.\d{0,2})?|(\.\d{1,2}))\)$)';
    */
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

    RegExp regExp = new RegExp(pattern);
    if (mail.length == 0) {
      return false;
    } else if (!regExp.hasMatch(mail)) {
      return false;
    }
    return true;
  }

  static bool validateMobile(String mobile) {
    //String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    String pattern = r'(^(\+|\d)[0-9]{7,16}$)';
    RegExp regExp = new RegExp(pattern);
    if (mobile.length == 0) {
      return false;
    } else if (!regExp.hasMatch(mobile)) {
      return false;
    }
    return true;
  }

  static bool validateOtp(String otp) {
    String pattern = r'(^([0-9]{4})$)';
    RegExp regExp = new RegExp(pattern);
    if (otp.length == 0) {
      return false;
    } else if (!regExp.hasMatch(otp)) {
      return false;
    }
    return true;
  }

  static bool validateName(String name) {
    String pattern = r'(^[A-z]*$|^[A-z]+\s[A-z]*$)';
    RegExp regExp = new RegExp(pattern);
    if (name.length == 0) {
      return false;
    } else if (!regExp.hasMatch(name)) {
      return false;
    }
    return true;
  }

  static bool isPasswordCompliant(String password, [int minLength = 6]) {
    if (password == null || password.isEmpty) {
      return false;
    }
    if (password.contains(' ')) {
      return false;
    }
    return true;
    /*bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > minLength;

    return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;*/
  }
}
