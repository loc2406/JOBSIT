import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/job.dart';
import '../../../core/services/job_services.dart';
import '../../../core/constants/convert_constants.dart';
import '../../../core/error/AppliedJobBeforeException.dart';
import '../../../core/constants/text_constants.dart';
import 'applied_job_state.dart';

class AppliedJobCubit extends Cubit<AppliedJobState> {
  AppliedJobCubit() : super(AppliedJobState.loading());

  final int _limit = 5;
  List<Job> _appliedJobs = [];

  List<Job> allAppliedJobs() => _appliedJobs;

  void clearAllAppliedJobs(){
    _appliedJobs = [];
    emit(AppliedJobState.empty());
  }

  Future<void> applyJob({required String token, required File cvFile, required String letter, required int idJob}) async {
    try{
      await JobServices.applyJob(token: token, cvFile: cvFile, letter: letter, idJob: idJob);
      emit(AppliedJobState.applySuccess());
      getAppliedJobs(token: token, no: 0);
    }catch (e) {
      if (e is AppliedJobBeforeException){
        emit(AppliedJobState.error(TextConstants.youAreAppliedThisJobMessage));
      }
      debugPrint(e.toString());
    }
  }

  getAppliedJobs({required String token, required int no}) async {
    emit(AppliedJobState.loading());
    try {
      final response =
          await JobServices.getAppliedJobs(token: token, no: no, limit: _limit);

      final jobs = response[JobServices.jobsKey];
      final isLastPage = response[JobServices.lastKey] == true;

      final appliedJobs = ConvertConstants.convertToListAppliedJobs(jobs);

      if (appliedJobs.isEmpty) {
        emit(AppliedJobState.empty());
      } else {
        if (no == 0){
          _appliedJobs = [];
        }

        _appliedJobs.addAll(appliedJobs);
        emit(AppliedJobState.loaded(appliedJobs: appliedJobs, page: no, isLastPage: isLastPage));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(AppliedJobState.error(TextConstants.getAppliedJobError));
    }
  }
}
