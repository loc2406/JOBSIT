
import '../../../data/models/job.dart';

class JobState {
  const JobState();

  factory JobState.empty() => JobEmptyState();

  factory JobState.loading() => JobLoadingState();

  factory JobState.loaded(
          {required List<Job> jobs,
          required int page,
          required String name,
          required bool isLastPage,
          required String location,
          required String schedule,
          required String position,
          required String major}) =>
      JobLoadedState(
          jobs: jobs,
          page: page,
          name: name,
          isLastPage: isLastPage,
          location: location,
          schedule: schedule,
          position: position,
          major: major);

  factory JobState.error(String errorMessage) => JobErrorState(errorMessage);

  factory JobState.viewDetail(
          Job job, List<Job> otherJobs, int page, bool isLastPage) =>
      JobDetailState(job, otherJobs, page, isLastPage);
}

class JobEmptyState extends JobState{}

class JobLoadingState extends JobState{}

class JobLoadedState extends JobState {
  final List<Job> jobs;
  final int page;
  final String name;
  final String location;
  final bool isLastPage;
  final String schedule;
  final String position;
  final String major;

  JobLoadedState(
      {required this.jobs,
      required this.page,
      required this.name,
      required this.isLastPage,
      required this.location,
      required this.schedule,
      required this.position,
      required this.major});
}

class JobErrorState extends JobState{

  final String errMessage;

  const JobErrorState(this.errMessage);
}

class JobDetailState extends JobState{
  final Job job;
  final List<Job> otherJobs;
  final int page;
  final bool isLastPage;

  JobDetailState(this.job, this.otherJobs, this.page, this.isLastPage);
}
