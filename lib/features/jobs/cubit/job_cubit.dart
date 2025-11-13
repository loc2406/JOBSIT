import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/core/constants/convert_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';

import '../../../data/models/job.dart';
import '../../../data/models/province.dart';
import '../../../core/services/job_services.dart';
import '../../../core/services/province_services.dart';
import 'job_state.dart';

class JobCubit extends Cubit<JobState> {
  JobCubit() : super(JobState.loading());

  final _limit = 5;

  Future<List<Province>> getProvinces() async {
    try {
      final provinces = await ProvinceServices.getProvinces();
      return provinces;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> getJobs(
      {required String name,
      required String address,
      required int scheduleId,
      required int positionId,
      required int  majorId,
      required int no}) async {
    emit(JobState.loading());

    try {
      final response = await JobServices.getJobs(
          name: name,
          address: address,
          scheduleId: scheduleId,
          positionId: positionId,
          majorId: majorId,
          no: no,
          limit: _limit);

      final jobs = ConvertConstants.convertToListJobs(response[JobServices.jobsKey]);
      final isLastPage = response[JobServices.lastKey] == true;

      if (jobs.isEmpty) {
        emit(JobState.empty());
      } else {
        emit(JobState.loaded(
          jobs: jobs,
          page: no,
          name: name,
          isLastPage: isLastPage,
          location: address,
          schedule: ConvertConstants.getNameById(ValueConstants.schedules, scheduleId),
          position:  ConvertConstants.getNameById(ValueConstants.positions, positionId),
          major:  ConvertConstants.getNameById(ValueConstants.majors, majorId),
        ));
      }
    } catch (e) {
      emit(JobState.error(e.toString()));
    }
  }

  Future<List<Job>> getOtherJobs(int no, Job job) async {
    final data = await JobServices.getOtherJobs(
        no: no, companyId: job.companyId, limit: 24);

    final jobs = data[JobServices.jobsKey];
    return ConvertConstants.convertToListJobs(jobs);
  }
}
