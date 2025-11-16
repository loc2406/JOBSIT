import 'package:jobsit_mobile/data/models/province.dart';

import '../../../data/models/job.dart';

class JobState {
  const JobState();

  factory JobState.empty() => JobEmptyState();

  factory JobState.loading() => JobLoadingState();

  factory JobState.loaded(
          {required List<Job> jobs,
          required int page,
          required int totalPages,
          required String searchKeyword,
          required String location,
          required String schedule,
          required String position,
          required String major}) =>
      JobLoadedState(
          jobs: jobs,
          page: page,
          totalPages: totalPages,
          searchKeyword: searchKeyword,
          location: location,
          schedule: schedule,
          position: position,
          major: major);

  factory JobState.error(String errorMessage) => JobErrorState(errorMessage);
}

class JobEmptyState extends JobState {}

class JobLoadingState extends JobState {}

class JobLoadedState extends JobState {
  final List<Job> jobs;
  final int page;
  final int totalPages;
  final String searchKeyword;
  final String location;
  final String schedule;
  final String position;
  final String major;

  JobLoadedState(
      {required this.jobs,
      required this.page,
      required this.totalPages,
      required this.searchKeyword,
      required this.location,
      required this.schedule,
      required this.position,
      required this.major});

  JobLoadedState copyWith({
    List<Job>? jobs,
    List<Province>? provinces,
    int? page,
    int? totalPages,
    String? searchKeyword,
    String? location,
    bool? isLastPage,
    String? schedule,
    String? position,
    String? major,
  }) {
    return JobLoadedState(
      jobs: jobs ?? this.jobs,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      location: location ?? this.location,
      schedule: schedule ?? this.schedule,
      position: position ?? this.position,
      major: major ?? this.major,
    );
  }
}

class JobErrorState extends JobState {
  final String errMessage;

  const JobErrorState(this.errMessage);
}
