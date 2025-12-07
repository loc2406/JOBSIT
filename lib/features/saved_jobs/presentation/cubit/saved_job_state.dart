import '../../../../data/models/job.dart';

class SavedJobState {
  const SavedJobState();

  factory SavedJobState.empty() => SavedJobEmptyState();

  factory SavedJobState.loading() => SavedJobLoadingState();

  factory SavedJobState.loaded({required List<Job> savedJobs, required bool isLastPage, required int page}) =>
      SavedJobLoadedState(savedJobs: savedJobs, isLastPage: isLastPage, page: page);

  factory SavedJobState.saveSuccess() => SavedJobSaveSuccessState();

  factory SavedJobState.deleteSuccess() => SavedJobDeleteSuccessState();
  factory SavedJobState.error(String errorMessage) => SavedJobErrorState(errorMessage);
}

class SavedJobEmptyState extends SavedJobState{}

class SavedJobLoadingState extends SavedJobState{}

class SavedJobLoadedState extends SavedJobState {
  final List<Job> savedJobs;
  final bool  isLastPage;
  final int page;

  SavedJobLoadedState({required this.savedJobs, required this.isLastPage, required this.page});
}

class SavedJobErrorState extends SavedJobState{

  final String errMessage;

  const SavedJobErrorState(this.errMessage);
}

class SavedJobSaveSuccessState extends SavedJobState{}

class SavedJobDeleteSuccessState extends SavedJobState{}