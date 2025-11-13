import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_state.dart';
import 'package:http/http.dart' as http;
import 'package:jobsit_mobile/core/constants/convert_constants.dart';
import 'package:jobsit_mobile/data/datasources/shared_prefs.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';

import '../../../data/models/candidate.dart';
import '../../../data/models/province.dart';
import '../../../data/models/university.dart';
import '../../../core/services/base_services.dart';
import '../../../core/services/candidate_services.dart';
import '../../../core/services/province_services.dart';

class CandidateCubit extends Cubit<CandidateState> {
  CandidateCubit() : super(CandidateState.noLoggedIn());

  Future<void> createCandidate(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone}) async {
    emit(CandidateState.loading());
    try {
      await CandidateServices.createCandidate(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone);
      emit(CandidateState.registerSuccess(email));
      sendActiveEmail(email);
    } catch (e) {
      emit(CandidateState.error(e.toString()));
    }
  }

  sendActiveEmail(String email) async {
    try {
      await CandidateServices.sendActiveEmail(email);
      emit(CandidateState.sendOtpSuccess());
    } catch (e) {
      emit(CandidateState.error(e.toString()));
    }
  }

  sendOtpToActiveAccount(String otp) async {
    try {
      emit(CandidateState.loading());
      await CandidateServices.sendOtpToActiveAccount(otp);
      emit(CandidateState.activeSuccess());
    } catch (e) {
      emit(CandidateState.error(ConvertConstants.getMessageFromException(e.toString())));
    }
  }

  loginAccount({required String email, required String password}) async {
    try {
      emit(CandidateState.loading());
      final responseBody =
          await CandidateServices.loginAccount(email, password);

      final token = responseBody[CandidateServices.tokenKey].toString();
      final candidateId =
          int.tryParse(responseBody[CandidateServices.idUserKey].toString());

      if (token.isNotEmpty && candidateId != null) {
        final candidate = await CandidateServices.getCandidateById(candidateId);
        await SharedPrefs.saveCandidateToken(token);
        await SharedPrefs.saveCandidateId(candidateId);
        emit(CandidateState.loginSuccess(token, candidate));
      } else {
        emit(CandidateState.error(TextConstants.tokenOrCandidateIdError));
      }
    } catch (e) {
      emit(CandidateState.error(ConvertConstants.getMessageFromException(e.toString())));
    }
  }

  sendOtpToChangePassWord(String otp, String password) async {
    try {
      emit(CandidateState.loading());
      await CandidateServices.sendOtpToChangePassWord(otp, password);
      emit(CandidateState.activeSuccess());
    } catch (e) {
      emit(CandidateState.error(e.toString()));
    }
  }

  sendEmailForgotPassWord(String email) async {
    try {
      await CandidateServices.sendEmailForgotPassWord(email);
      emit(CandidateState.sendOtpSuccess());
    } catch (e) {
      emit(CandidateState.error(e.toString()));
    }
  }

  Future<List<Province>> getProvinces() async {
    try {
      final provinces = await ProvinceServices.getProvinces();
      return provinces;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>?> verifyOtp(String otp) async {
    try {
      final response = await CandidateServices.verifyOtp(otp);
      return response;
    } catch (e) {
      debugPrint('❌ Lỗi khi gọi API: $e');
      return null;
    }
  }

  handleUpdate(
      {required Candidate user,
      required String token,
      required List<int> position,
      required List<int> major,
      required List<int> jobType,
      required String wantJob,
      required String desiredWorkingProvince,
      required String coverLetter,
      required File cv,
      }) async {
    try {
      emit(CandidateState.loading());
      final responseBody = await CandidateServices.updateCandidateJob(
          user: user,
          token: token,
          position: position,
          major: major,
          jobType: jobType,
          wantJob: wantJob,
          desiredWorkingProvince: desiredWorkingProvince,
          coverLetter: coverLetter,
          cv: cv,
      );
      final candidate = await CandidateServices.getCandidateById(user.id);
      emit(CandidateState.loginSuccess(token, candidate));
    } catch (e) {
      emit(CandidateState.error(e.toString()));
    }
  }

  Future<List<String>> getDistricts(int provinceCode) async {
    try {
      final districts = await ProvinceServices.getDistricts(provinceCode);
      return districts;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<University>> getUniversities() async {
    try {
      final universities = await CandidateServices.getUniversities();
      return universities;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  updateInfo({
    required int candidateId,
    required String token,
    required File? avatar,
    required String firstName,
    required String lastName,
    required String birthdate,
    required String phone,
    required bool? gender,
    required String location,
    University? university,
  }) async {
    try {
      emit(CandidateState.loading());

      await CandidateServices.updateCandidate(
          candidateId: candidateId,
          token: token,
          avatar: avatar,
          firstName: firstName,
          lastName: lastName,
          birthdate: birthdate,
          phone: phone,
          gender: gender,
          location: location,
          university: university);

      emit(CandidateState.editSuccess());

      final candidate = await CandidateServices.getCandidateById(candidateId);
      emit(CandidateState.loginSuccess(token, candidate));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateSearchable(int id, String token) async {
    try {
      await CandidateServices.updateSearchable(token);
      final candidate = await CandidateServices.getCandidateById(id);
      emit(CandidateState.loginSuccess(token, candidate));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateMailReceive(int id, String token) async {
    try {
      await CandidateServices.updateMailReceive(id, token);
      final candidate = await CandidateServices.getCandidateById(id);
      emit(CandidateState.loginSuccess(token, candidate));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> logout(String token) async {
    try {
      emit(CandidateState.loading());
      await CandidateServices.logout(token);
      emit(CandidateState.noLoggedIn());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void setLoginStatus(
      {required bool status, String? token, Candidate? candidate}) {
    if (status) {
      emit(CandidateState.loginSuccess(token!, candidate!));
    } else {
      emit(CandidateState.noLoggedIn());
    }
  }
}
