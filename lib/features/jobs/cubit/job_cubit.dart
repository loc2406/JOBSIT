import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/core/constants/convert_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/utils/logger/app_logger.dart';
import 'package:jobsit_mobile/data/models/province.dart';

import '../../../data/models/job.dart';
import '../../../core/services/job_services.dart';
import '../../../core/services/province_services.dart';
import 'job_state.dart';

class JobCubit extends Cubit<JobState> {
  JobCubit() : super(JobState.loading());

  final _limit = 5;
  List<Province> _provinces = [];
  bool _isLoadedProvinces = false;

  Future<void> getJobs(
      {required String searchKeyword,
      required String location,
      required int scheduleId,
      required int positionId,
      required int majorId,
      required int page}) async {
    emit(JobState.loading());

    try {
      final result = await JobServices.getJobs(
          searchKeyword: searchKeyword,
          location: location,
          scheduleId: scheduleId,
          positionId: positionId,
          majorId: majorId,
          page: page,
          limit: _limit);

      if (!_isLoadedProvinces) {
        _provinces = await ProvinceServices.getProvinces();
        _isLoadedProvinces = true;
      }

      final jobs =
          ConvertConstants.convertToListJobs(result[JobServices.jobsKey]);
      final currentPage =
          int.tryParse(result[JobServices.pageKey].toString()) ?? 1;
      final totalPages =
          int.tryParse(result[JobServices.totalPageKey].toString()) ?? 1;

      if (jobs.isEmpty) {
        emit(JobState.empty());
      } else {
        emit(JobState.loaded(
          jobs: jobs,
          provinces: _provinces,
          page: currentPage,
          searchKeyword: searchKeyword,
          totalPages: totalPages,
          location: location,
          schedule: ConvertConstants.getNameById(
              ValueConstants.schedules, scheduleId),
          position: ConvertConstants.getNameById(
              ValueConstants.positions, positionId),
          major: ConvertConstants.getNameById(ValueConstants.majors, majorId),
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
