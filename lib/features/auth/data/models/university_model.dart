import 'package:jobsit_mobile/features/auth/domain/entities/university.dart';

class UniversityModel extends University{

  UniversityModel(super.id, super.name);

  factory UniversityModel.fromJson(Map<String, dynamic> map){
    return UniversityModel(
        int.parse(map[idKey].toString()), map[nameKey].toString());
  }

  static const idKey = 'id';
  static const nameKey = 'name';
}