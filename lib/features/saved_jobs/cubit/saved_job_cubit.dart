import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/job.dart';
import '../../../core/services/job_services.dart';
import '../../../core/constants/convert_constants.dart';
import 'saved_job_state.dart';

class SavedJobCubit extends Cubit<SavedJobState> {
  SavedJobCubit() : super(SavedJobState.loading());

  final int _limit = 5;
  List<Job> _savedJobs = [];

  List<Job> allSavedJobs() => _savedJobs;

  void clearAllSavedJobs(){
    _savedJobs = [];
    emit(SavedJobState.empty());
  }

  getSavedJobs({required String token, required int no}) async {
    emit(SavedJobState.loading());
    try {
      final response =
      await JobServices.getSavedJobs(token: token, no: no, limit: _limit);

      final jobs = response[JobServices.jobsKey];
      final isLastPage = response[JobServices.lastKey] == true;

      final savedJobs = ConvertConstants.convertToListSavedJobs(jobs);

      if (no == 0) {
        _savedJobs.clear();
      }

      if (savedJobs.isEmpty) {
        emit(SavedJobState.empty());
      } else {
        _savedJobs.addAll(savedJobs);
        emit(SavedJobState.loaded(savedJobs: List.from(_savedJobs), page: no, isLastPage: isLastPage));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  saveJob(int jobId, String token) async {
    emit(SavedJobState.loading());
    try {
      await JobServices.saveJob(jobId: jobId, token: token);
      _savedJobs.clear();
      await getSavedJobs(token: token, no: 0);
      emit(SavedJobState.saveSuccess());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  deleteJob(int jobId, String token) async {
    emit(SavedJobState.loading());
    try {
      await JobServices.deleteJob(jobId: jobId, token: token);
      _savedJobs.clear();
      await getSavedJobs(token: token, no: 0);
      emit(SavedJobState.deleteSuccess());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
