import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:jobsit_mobile/data/datasources/shared_prefs.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_state.dart';
import 'package:jobsit_mobile/features/jobs/cubit/job_cubit.dart';
import 'package:jobsit_mobile/features/jobs/cubit/job_state.dart';
import 'package:jobsit_mobile/features/saved_jobs/cubit/saved_job_state.dart';
import 'package:jobsit_mobile/features/auth/screens/login_screen.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/convert_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/shared/widgets/filter_bottom_sheet.dart';
import 'package:jobsit_mobile/shared/widgets/job_item.dart';
import 'package:jobsit_mobile/shared/widgets/number_paginator.dart';

import '../../auth/cubit/candidate_cubit.dart';
import '../../saved_jobs/cubit/saved_job_cubit.dart';
import '../../../data/models/job.dart';
import '../../../core/constants/asset_constants.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  late final JobCubit _jobCubit;
  late final CandidateCubit _candidateCubit;
  late final SavedJobCubit _savedJobCubit;

  final _searchController = TextEditingController();

  String _selectedLocation = '';
  String _selectedSchedule = '';
  String _selectedPosition = '';
  String _selectedMajor = '';
  final Debouncer _debouncer = Debouncer();

  ThemeData get _theme => Theme.of(context);

  @override
  void initState() {
    super.initState();

    _jobCubit = context.read<JobCubit>();
    _candidateCubit = context.read<CandidateCubit>();
    _savedJobCubit = context.read<SavedJobCubit>();

    _getJobs(page: 1);
  }

  Future<void> _getJobs({required int page}) async {
    await _jobCubit.getJobs(
        page: page,
        searchKeyword: _searchController.text,
        location: _selectedLocation,
        scheduleId: _selectedSchedule.isNotEmpty
            ? ConvertConstants.getIdByName(
                ValueConstants.schedules, _selectedSchedule)
            : -1,
        positionId: _selectedPosition.isNotEmpty
            ? ConvertConstants.getIdByName(
                ValueConstants.positions, _selectedPosition)
            : -1,
        majorId: _selectedMajor.isNotEmpty
            ? ConvertConstants.getIdByName(
                ValueConstants.majors, _selectedMajor)
            : -1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            margin: EdgeInsets.only(
                left: ValueConstants.deviceWidthValue(uiValue: 25)),
            child: Image.asset(
              AssetConstants.logoHome,
            ),
          ),
          leadingWidth: ValueConstants.deviceWidthValue(uiValue: 143),
          actions: [
            GestureDetector(
              onTapDown: _showLanguages,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                      BorderSide(color: _theme.primaryColor, width: 2)),
                ),
                child: ClipOval(
                  child: Image.asset(
                    context.locale.languageCode == 'vi'
                        ? AssetConstants.viFlag
                        : AssetConstants.enFlag,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(
            left: 15,
            top: 20,
            right: 15,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _searchController,
                    onChanged: (keyword) => handleFilterJobs(),
                    decoration: InputDecoration(
                        hintText: 'screen.job.search_job'.tr(),
                        suffixIcon: const Icon(
                          Icons.search,
                          size: 24,
                          color: ColorConstants.main,
                        )),
                  )),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: showFilter,
                    child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          border: Border.fromBorderSide(BorderSide(
                            color: ColorConstants.main,
                          ))),
                      child: Icon(
                        Icons.filter_alt,
                        color: _theme.primaryColor,
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: MultiBlocListener(listeners: [
                  BlocListener<JobCubit, JobState>(
                    listener: (context, state) {
                      if (state is JobLoadedState) {
                        // _selectedLocation = state.location;
                        // _selectedSchedule = state.schedule;
                        // _selectedPosition = state.position;
                        // _selectedMajor = state.major;
                      }
                    },
                    child: const SizedBox(),
                  ),
                  BlocListener<SavedJobCubit, SavedJobState>(
                      listener: (context, state) {
                    if (state is SavedJobSaveSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(TextConstants.saveJobSuccessful)));
                    } else if (state is SavedJobDeleteSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(TextConstants.deleteJobSuccessful)));
                    }
                  })
                ], child: _buildJobList()),
              ),
            ],
          ),
        ));
  }

  void _showLanguages(TapDownDetails details) {
    final position = details.globalPosition;

    showMenu(
      context: context,
      items: [
        PopupMenuItem(
          value: 'vi',
          child: Row(
            children: [
              ClipOval(
                  child: Image.asset(
                AssetConstants.viFlag,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              )),
              const SizedBox(
                width: 3,
              ),
              Text(
                'language.vi'.tr(),
                style: const TextStyle(color: Colors.black, fontSize: 10),
              )
            ],
          ),
          onTap: () async => await _changeLanguage('vi'),
        ),
        PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              ClipOval(
                  child: Image.asset(
                AssetConstants.enFlag,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              )),
              const SizedBox(
                width: 3,
              ),
              Text(
                'language.en'.tr(),
                style: const TextStyle(color: Colors.black, fontSize: 10),
              )
            ],
          ),
          onTap: () async => await _changeLanguage('en'),
        ),
      ],
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + 28, // Đẩy menu xuống dưới Container
        position.dx,
        position.dy + 28, // Đẩy menu xuống dưới Container
      ),
    );
  }

  Future<void> _changeLanguage(String selectedLanguageCode) async {
    if (selectedLanguageCode != context.locale.languageCode) {
      await context.setLocale(Locale(selectedLanguageCode));
      await SharedPrefs.setLanguageCode(selectedLanguageCode);
    }
  }

  Widget _buildJobList() {
    return BlocBuilder<JobCubit, JobState>(
      builder: (context, state) {
        switch (state) {
          case JobEmptyState():
            return Center(
                child: Text('notification.no_job_to_show'.tr(),
                    style: _theme.textTheme.displayMedium));
          case JobLoadingState():
            return Center(
                child: CircularProgressIndicator(
              color: _theme.primaryColor,
            ));
          case JobErrorState():
            return Center(
                child: Text(
              'error.something_wrong_please_restart_app'.tr(),
              style: _theme.textTheme.displayMedium,
              textAlign: TextAlign.center,
            ));
          case JobLoadedState():
            return Column(
              children: [
                NumberPaginator(
                  currentPage: state.page,
                  totalPages: state.totalPages,
                  onPageChange: (newPage) async => await _navigatePage(newPage),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListView.separated(
                        itemCount: state.jobs.length,
                        itemBuilder: (context, index) {
                          final job = state.jobs[index];

                          return JobItem(
                            job: job,
                            onIconBookmarkClicked: () async =>
                                await handleIcBookmarkClicked(job),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                      )),
                ),
              ],
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  Future<void> _navigatePage(int newPage) async {
    if (_jobCubit.state is JobLoadingState) {
    return;
  }
  
    await _getJobs(page: newPage);
  }

  void showFilter() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                FilterBottomSheet(
                  provinces: [],
                  selectedLocation: _selectedLocation,
                  selectedSchedule: _selectedSchedule,
                  selectedPosition: _selectedPosition,
                  selectedMajor: _selectedMajor,
                  onApply: (location, schedule, position, major) async {
                    _selectedLocation = location;
                    _selectedSchedule = schedule;
                    _selectedPosition = position;
                    _selectedMajor = major;

                    await handleFilterJobs();
                  },
                )
              ],
            ));
  }

  Future<void> handleFilterJobs() async {
    // _pagingController.itemList = [];
    // _getJobs(0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> handleIcBookmarkClicked(Job job) async {
    if (_candidateCubit.state is AuthNoLoggedInState) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }

    _debouncer.debounce(
        duration: const Duration(seconds: 3),
        onDebounce: () async {
          if (_candidateCubit.state is AuthLoginSuccessState) {
            final candidateToken =
                (_candidateCubit.state as AuthLoginSuccessState).token;
            final isSaved =
                _savedJobCubit.allSavedJobs().any((j) => j.jobId == job.jobId);

            if (!isSaved) {
              await _savedJobCubit.saveJob(job.jobId, candidateToken);
            } else {
              await _savedJobCubit.deleteJob(job.jobId, candidateToken);
            }
          }
        });
  }
}
