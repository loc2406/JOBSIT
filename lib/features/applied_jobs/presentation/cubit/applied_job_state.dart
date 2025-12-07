import '../../../../data/models/job.dart';

class AppliedJobState {
  const AppliedJobState();

  factory AppliedJobState.empty() => AppliedJobEmptyState();

  factory AppliedJobState.loading() => AppliedJobLoadingState();

  factory AppliedJobState.loaded({required List<Job> appliedJobs, required bool isLastPage, required int page}) =>
      AppliedJobLoadedState(appliedJobs: appliedJobs, isLastPage: isLastPage, page: page);

  factory AppliedJobState.applySuccess() => AppliedJobSuccessState();

  factory AppliedJobState.error(String errorMessage) => AppliedJobErrorState(errorMessage);
}

class AppliedJobEmptyState extends AppliedJobState{}

class AppliedJobLoadingState extends AppliedJobState{}

class AppliedJobLoadedState extends AppliedJobState {
  final List<Job> appliedJobs;
  final bool  isLastPage;
  final int page;

  AppliedJobLoadedState({required this.appliedJobs, required this.isLastPage, required this.page});
}

class AppliedJobErrorState extends AppliedJobState {
  final String errMessage;

  const AppliedJobErrorState(this.errMessage);
}

class AppliedJobSuccessState extends AppliedJobState{}