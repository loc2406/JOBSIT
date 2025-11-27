import 'package:jobsit_mobile/features/auth/domain/entities/university.dart';

class Candidate {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isMale;
  final String? birthdate;
  final String phone;
  final String? avatar;
  final String? location;
  final bool mailReceive;
  final bool searchable;
  final University? university;
  final String? cv;
  final List<Map<String, dynamic>>? positionDTOs;
  final List<Map<String, dynamic>>? majorDTOs;
  final List<Map<String, dynamic>>? scheduleDTOs;
  final String? desiredJob;
  final String? referenceLetter;
  final String? desiredWorkingProvince;
  const Candidate(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      this.isMale = true,
      this.birthdate,
      required this.phone,
      this.avatar,
      this.location,
      required this.mailReceive,
      required this.searchable,
      this.university,
      this.cv,
      this.majorDTOs,
      this.positionDTOs,
      this.scheduleDTOs,
      this.desiredJob,
      this.referenceLetter,
      this.desiredWorkingProvince});
}
