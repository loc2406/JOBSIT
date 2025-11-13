class Province{
  final int code;
  final String name;

  Province(this.code, this.name);

  factory Province.fromMap(Map<String, dynamic> map){
    return Province(
        int.parse(map[codeKey].toString()), map[nameKey].toString());
  }

  static const codeKey = 'code';
  static const nameKey = 'name';
}