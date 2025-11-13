class University{
  final int id;
  final String name;

  University(this.id, this.name);

  factory University.fromMap(Map<String, dynamic> map){
    return University(
        int.parse(map[idKey].toString()), map[nameKey].toString());
  }

  static const idKey = 'id';
  static const nameKey = 'name';
}