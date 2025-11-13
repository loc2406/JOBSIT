import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jobsit_mobile/features/auth/cubit/candidate_state.dart';
import 'package:jobsit_mobile/features/jobs/cubit/job_cubit.dart';
import 'package:jobsit_mobile/features/jobs/cubit/job_state.dart';
import 'package:jobsit_mobile/features/saved_jobs/cubit/saved_job_state.dart';
import 'package:jobsit_mobile/features/auth/screens/login_screen.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/convert_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/utils/widget_constants.dart';
import 'package:jobsit_mobile/shared/widgets/filter_bottom_sheet.dart';
import 'package:jobsit_mobile/shared/widgets/job_item.dart';

import '../../auth/cubit/candidate_cubit.dart';
import '../../saved_jobs/cubit/saved_job_cubit.dart';
import '../../../data/models/job.dart';
import '../../../data/models/province.dart';
import '../../../core/constants/asset_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final JobCubit _jobCubit;
  late final CandidateCubit _candidateCubit;
  late final SavedJobCubit _savedJobCubit;
  List<Province> _provinces = [];
  final _searchController = TextEditingController();
  final PagingController<int, Job> _pagingController =
  PagingController(firstPageKey: 0);
  String _selectedLocation = '';
  String _selectedSchedule = '';
  String _selectedPosition = '';
  String _selectedMajor = '';
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _jobCubit = context.read<JobCubit>();
    _candidateCubit = context.read<CandidateCubit>();
    _savedJobCubit = context.read<SavedJobCubit>();
    _getProvinces();
    _pagingController.addPageRequestListener((pageKey) async {
      await _getJobs(pageKey+1);
    });
  }

  Future<void> _getProvinces() async {
    final provinces = await _jobCubit.getProvinces();
    setState(() {
      _provinces = provinces;
    });
  }

  Future<void> _getJobs(int no) async {
    debugPrint('_getJobs: $no $_selectedLocation $_selectedSchedule $_selectedPosition $_selectedMajor');
    await _jobCubit.getJobs(
        name: _searchController.text,
        address: _selectedLocation,
        scheduleId: _selectedSchedule.isNotEmpty ? ConvertConstants.getIdByName(ValueConstants.schedules, _selectedSchedule) : -1,
        positionId: _selectedPosition.isNotEmpty ? ConvertConstants.getIdByName(ValueConstants.positions, _selectedPosition) : -1,
        majorId: _selectedMajor.isNotEmpty ? ConvertConstants.getIdByName(ValueConstants.majors, _selectedMajor) : -1,
        no: no);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
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
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                      BorderSide(color: ColorConstants.main, width: 2)),),
                child: ClipOval(child: Image.asset(
                  AssetConstants.iconVN, fit: BoxFit.cover,),),
              ),
            ),
            SizedBox(
              width: ValueConstants.deviceWidthValue(uiValue: 25),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(
            left: ValueConstants.deviceWidthValue(uiValue: 25),
            top: ValueConstants.deviceHeightValue(uiValue: 25),
            right: ValueConstants.deviceWidthValue(uiValue: 25),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (keyword) => handleFilterJobs(),
                        decoration: const InputDecoration(
                            hintText: TextConstants.searchJob,
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 13),
                            fillColor: Colors.white,
                            filled: true,
                            suffixIcon: Icon(
                              Icons.search,
                              color: ColorConstants.main,
                            ),
                            focusedBorder: WidgetConstants.searchBorder,
                            enabledBorder: WidgetConstants.searchBorder),
                      )),
                  SizedBox(width: ValueConstants.deviceWidthValue(uiValue: 8)),
                  GestureDetector(
                    onTap: showFilter,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.fromBorderSide(BorderSide(
                            color: ColorConstants.main,
                          ))),
                      child: SvgPicture.asset(AssetConstants.iconFilter),
                    ),
                  )
                ],
              ),
              Expanded(
                child: MultiBlocListener(listeners: [
                  BlocListener<JobCubit, JobState>(
                    listener: (context, state) {
                      if (state is JobLoadedState) {
                        _selectedLocation = state.location;
                        _selectedSchedule = state.schedule;
                        _selectedPosition = state.position;
                        _selectedMajor = state.major;

                        if (state.isLastPage) {
                          _pagingController.appendLastPage(state.jobs);
                        } else {
                          _pagingController.appendPage(
                              state.jobs, state.page + 1);
                        }
                      } else if (state is JobErrorState) {
                        _pagingController.error = state.errMessage;
                      } else if (state is JobEmptyState) {
                        _pagingController.itemList = [];
                      }
                    },
                    child: const SizedBox(),
                  ),
                  BlocListener<SavedJobCubit, SavedJobState>(
                      listener: (context, state) {
                        if (state is SavedJobSaveSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(duration: Duration(seconds: 2), content: Text(
                                  TextConstants.saveJobSuccessful)));
                        } else if (state is SavedJobDeleteSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(duration: Duration(seconds: 2),content: Text(
                                  TextConstants.deleteJobSuccessful)));
                        }
                      })
                ], child: _buildJobList()),
              ),
            ],
          ),
        ));
  }

  Widget _buildJobList() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ValueConstants.deviceWidthValue(uiValue: 15)),
      child: PagedListView<int, Job>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Job>(
            itemBuilder: (context, job, index) {
              return JobItem(job: job,
                onIconBookmarkClicked: () async =>
                await handleIcBookmarkClicked(job),);
            },
            newPageProgressIndicatorBuilder: (_) =>
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: WidgetConstants.circularProgress,
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) {
              if (_searchController.text.isEmpty || _selectedLocation.isEmpty) {
                return const Center(
                  child: Text(
                    TextConstants.notFindJobMess,
                    style: WidgetConstants.mainBold16Style,
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    TextConstants.noMatchingJobAtThisTimeMess,
                    style: WidgetConstants.mainBold16Style,
                  ),
                );
              }
            }),
      ),
    );
  }

  void showFilter() {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            Wrap(
              children: [
                FilterBottomSheet(
                  provinces: _provinces,
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
    _pagingController.itemList = [];
    _getJobs(0);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> handleIcBookmarkClicked(Job job) async {
    if (_candidateCubit.state is AuthNoLoggedInState) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }

    _debouncer.debounce(duration: const Duration(seconds: 3), onDebounce: () async {
      if (_candidateCubit.state is AuthLoginSuccessState) {
        final candidateToken = (_candidateCubit.state as AuthLoginSuccessState)
            .token;
        final isSaved = _savedJobCubit.allSavedJobs().any((j) =>
        j.jobId == job.jobId);

        if (!isSaved) {
          await _savedJobCubit.saveJob(job.jobId, candidateToken);
        } else {
          await _savedJobCubit.deleteJob(job.jobId, candidateToken);
        }
      }
    });
  }
}
