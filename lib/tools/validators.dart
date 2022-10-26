class CustomValidator {
  static String? required(dynamic value) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return "ne peut pas être vide";
    }
    return null;
  }

  static String? min4Max40(dynamic value) {
    String? ret;
    if ((ret = required(value)) != null) return ret;
    if ((value is Iterable || value is String || value is Map) &&
        (value.length < 4 || value.length > 40)) {
      return "Doit être compris entre 4 et 40 charactere";
    }
    return null;
  }

  static String? max100(dynamic value) {
    if ((value is Iterable || value is String || value is Map) &&
        (value.length > 100)) {
      return "Ne doit pas excéder 100 charactere";
    }
    return null;
  }
}