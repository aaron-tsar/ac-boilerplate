


class Validator {
  static final Validator instance = Validator();
  final phoneRegex = RegExp(r"^84(?!0)\d{9,}$");
  final mentionRegex = RegExp(r"\B@[\w\d_\-\n.]{1,32}");
  final numberOnly = RegExp(r"^[0-9]*");
  final alphabetNumberWhiteSpaceOnly = RegExp(r"^[a-zA-Z0-9 ]*");
  final imageUrl=RegExp(r'\.(jpg|jpeg|png|gif|bmp|svg)$');
  final urlFinderRegex = RegExp(
      r"[-a-zA-Z0-9@:%_\+.~#?&//=]+\.[a-z]+\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)?");
  final httpUrl=  RegExp(
    r'^(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(\/\S*)?$',
  );
  bool isValidPhone(String? data) => (data?.length ?? 0) >= 9;
  bool isEmpty(String? data)=> (data??"").isEmpty;

  bool isAbleToConvertToNumber(String data) {
    final validNumberReg = RegExp(r"^(\d+(\,\d{3})*(\.\d{1,})?)?$");
    return validNumberReg.hasMatch(data.trim());
  }
  bool isValidUrl(String? data) {
    if (data == null || data.trim().isEmpty) return false;
    return urlFinderRegex.hasMatch(data);
  }  bool isValidHttpUrl(String? data) {
    if (data == null || data.trim().isEmpty) return false;
    return httpUrl.hasMatch(data);
  }
  bool isImageUrl(String? data) {
    if (data == null || data.trim().isEmpty) return false;
    return imageUrl.hasMatch(data);
  }

  bool isValidEmail(String? email) {
    if (email == null) return false;

    final emailRegExp =
    RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool isValidPassword(String? password) {
    return password != null && password.length >= 8;
  }

  bool isValidLicensePlate(String? plate) {
    if(plate == null) return false;
    return RegExp('\\d{2,2}[\\w\\d]{2,2}-\\d{3,3}\\.\\d{2,2}').hasMatch(plate);
  }

  bool isValidOtp(String? otp) {
    if (otp == null) return false;
    return otp.length == 6;
  }

  bool isValidResetPassword(String? password, String? rePassword) {
    if (rePassword == null) return false;
    return isValidPassword(rePassword) && rePassword == password;
  }

  bool isValidUserName(String? input) {
    if(input == null) return false;
    RegExp regex = RegExp(r'^[a-zA-Z0-9]{6,}$');
    return regex.hasMatch(input);
  }
}
