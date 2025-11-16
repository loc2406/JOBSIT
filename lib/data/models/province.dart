class Province {
  final int code;
  final String name;

  Province(this.code, this.name);

  factory Province.fromMap(Map<String, dynamic> map) {
    String originalName = map[nameKey].toString();
    String cleanedName =
        originalName.replaceFirst("Thành phố ", "").replaceFirst("Tỉnh ", "");

    return Province(int.parse(map[codeKey].toString()), cleanedName);
  }

  static const codeKey = 'code';
  static const nameKey = 'name';
}
