import 'package:jobsit_mobile/features/auth/data/models/university_model.dart';
import 'package:jobsit_mobile/features/auth/domain/entities/candidate.dart';

class CandidateModel extends Candidate{
  CandidateModel(
      {required super.id,
      required super.email,
      required super.firstName,
      required super.lastName,
      super.isMale,
      super.birthdate,
      required super.phone,
      super.avatar,
      super.location,
      super.mailReceive = false,
      super.searchable = false,
      super.university,
      super.cv,
      super.majorDTOs,
      super.positionDTOs,
      super.scheduleDTOs,
      super.desiredJob,
      super.referenceLetter,
      super.desiredWorkingProvince});

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
        id: int.parse(json[idField].toString()),
        email: json[emailField] ?? '',
        firstName: json[firstNameField] ?? '',
        lastName: json[lastNameField] ?? '',
        isMale: json[isMaleField],
        birthdate: json[birthDayField],
        phone: json[phoneField],
        avatar: json[avatarField],
        location: json[locationField],
        mailReceive: json[mailReceiveField] ?? false,
        searchable: json[searchableField] ?? false,
        university: json[universityField] != null
            ? UniversityModel.fromJson(json[universityField])
            : null,
        cv: json[cvField],
        positionDTOs: json[positionDTOsField] != null
            ? List<Map<String, dynamic>>.from(json[positionDTOsField])
            : null,
        majorDTOs: json[majorDTOsField] != null
            ? List<Map<String, dynamic>>.from(json[majorDTOsField])
            : null,
        scheduleDTOs: json[scheduleDTOsField] != null
            ? List<Map<String, dynamic>>.from(json[scheduleDTOsField])
            : null,
        desiredJob: json[desiredJobField],
        referenceLetter: json[referenceLetterField],
        desiredWorkingProvince: json[desiredWorkingProvinceField]);
  }

  static const idField = 'id';
  static const emailField = 'email';
  static const firstNameField = 'firstName';
  static const lastNameField = 'lastName';
  static const isMaleField = 'isMale';
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