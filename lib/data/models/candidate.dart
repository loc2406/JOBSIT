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
  const Candidate({required this.id,
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
    this.desiredWorkingProvince
  });

  factory Candidate.fromMap(Map<String, dynamic> map) {
    return Candidate(
      id: int.parse(map[CandidateServices.userDTOKey][idField].toString()),
      email: map[CandidateServices.userDTOKey][emailField] ?? '',
      firstName: map[CandidateServices.userDTOKey][firstNameField] ?? "",
      lastName: map[CandidateServices.userDTOKey][lastNameField] ?? "",
      gender: map[CandidateServices.userDTOKey][genderField] ?? false,
      birthdate: map[CandidateServices.userDTOKey][birthDayField] ?? "",
      phone: map[CandidateServices.userDTOKey][phoneField] ?? "",
      avatar: map[CandidateServices.userDTOKey][avatarField] ?? "",
      location: map[CandidateServices.userDTOKey][locationField] ?? "",
      mailReceive: map[CandidateServices.userDTOKey][mailReceiveField] ?? false,
      searchable: map[CandidateServices.candidateOtherInfoDTOKey][searchableField] ?? false,
      university: map[CandidateServices.candidateOtherInfoDTOKey][universityDTOField] != null ?University.fromMap(map[CandidateServices.candidateOtherInfoDTOKey][universityDTOField]) : null,
      cv: map[CandidateServices.candidateOtherInfoDTOKey][cvField],
        positionDTOs: map[CandidateServices.candidateOtherInfoDTOKey][positionDTOsField] != null
            ? List<Map<String, dynamic>>.from(map[CandidateServices.candidateOtherInfoDTOKey]['positionDTOs'])
            : null,
        majorDTOs: map[CandidateServices.candidateOtherInfoDTOKey][majorDTOsField] != null
            ? List<Map<String, dynamic>>.from(map[CandidateServices.candidateOtherInfoDTOKey]['majorDTOs'])
            : null,
        scheduleDTOs: map[CandidateServices.candidateOtherInfoDTOKey][scheduleDTOsField] != null
            ? List<Map<String, dynamic>>.from(map[CandidateServices.candidateOtherInfoDTOKey]['scheduleDTOs'])
            : null,
        desiredJob: map[CandidateServices.candidateOtherInfoDTOKey]?[desiredJobField]?? '',
        referenceLetter: map[CandidateServices.candidateOtherInfoDTOKey]?[referenceLetterField] ?? '',
        desiredWorkingProvince: map[CandidateServices.candidateOtherInfoDTOKey]?[desiredWorkingProvinceField] ?? ''
    );
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
  static const universityDTOField = 'universityDTO';
  static const cvField = 'cv';
  static const positionDTOsField = 'positionDTOs';
  static const majorDTOsField = 'majorDTOs';
  static const scheduleDTOsField = 'scheduleDTOs';
  static const desiredJobField = 'desiredJob';
  static const referenceLetterField = 'referenceLetter';
  static const desiredWorkingProvinceField ='desiredWorkingProvince';
}
