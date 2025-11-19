import 'package:jobsit_mobile/data/models/university.dart';
import 'package:jobsit_mobile/core/services/candidate_services.dart';

class Candidate {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool? gender;
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
      this.gender,
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

  factory Candidate.fromMap(Map<String, dynamic> map) {
    return Candidate(
        id: int.parse(map[idField].toString()),
        email: map[emailField] ?? '',
        firstName: map[firstNameField] ?? "",
        lastName: map[lastNameField] ?? "",
        gender: map[genderField],
        birthdate: map[birthDayField],
        phone: map[phoneField],
        avatar: map[avatarField],
        location: map[locationField],
        mailReceive: map[mailReceiveField] ?? false,
        searchable: map[searchableField] ?? false,
        university: map[universityField] != null
            ? University.fromMap(map[universityField])
            : null,
        cv: map[cvField],
        positionDTOs: map[positionDTOsField] != null
            ? List<Map<String, dynamic>>.from(map[positionDTOsField])
            : null,
        majorDTOs: map[majorDTOsField] != null
            ? List<Map<String, dynamic>>.from(map[majorDTOsField])
            : null,
        scheduleDTOs: map[scheduleDTOsField] != null
            ? List<Map<String, dynamic>>.from(map[scheduleDTOsField])
            : null,
        desiredJob: map[desiredJobField],
        referenceLetter: map[referenceLetterField],
        desiredWorkingProvince: map[desiredWorkingProvinceField]);
  }

  // Model
  static const idField = 'id';
  static const emailField = 'email';
  static const firstNameField = 'firstName';
  static const lastNameField = 'lastName';
  static const genderField = 'gender';
  static const birthDayField = 'birthDay';
  static const phoneField = 'phone';
  static const avatarField = 'avatar';
  static const locationField = 'location';
  static const mailReceiveField = 'mailReceive';
  static const searchableField = 'searchable';
  static const universityField = 'university';
  static const cvField = 'cv';
  static const positionDTOsField = 'positionDTOs';
  static const majorDTOsField = 'majorDTOs';
  static const scheduleDTOsField = 'scheduleDTOs';
  static const desiredJobField = 'desiredJob';
  static const referenceLetterField = 'referenceLetter';
  static const desiredWorkingProvinceField = 'desiredWorkingProvince';
}
