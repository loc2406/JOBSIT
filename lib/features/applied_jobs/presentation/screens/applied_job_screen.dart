// lib/screens/applied_job_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jobsit_mobile/features/applied_jobs/presentation/cubit/applied_job_cubit.dart';
import 'package:jobsit_mobile/features/applied_jobs/presentation/cubit/applied_job_state.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_state.dart';
import 'package:jobsit_mobile/data/models/job.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/constants/widget_constants.dart';
import 'package:jobsit_mobile/shared/widgets/job_item.dart';

class AppliedJobScreen extends StatefulWidget {
  const AppliedJobScreen({super.key});

  @override
  State<AppliedJobScreen> createState() => _AppliedJobScreenState();
}

class _AppliedJobScreenState extends State<AppliedJobScreen> {
  late final CandidateCubit _candidateCubit;
  late final AppliedJobCubit _appliedJobCubit;
  PagingController<int, Job> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _candidateCubit = context.read<CandidateCubit>();
    _appliedJobCubit = context.read<AppliedJobCubit>();
    _initializePagingController();
  }

  void _initializePagingController() {
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) async {
      final state = _candidateCubit.state;
      if (state is AuthLoginSuccessState) {
        await _getAppliedJobs(token: state.token, no: pageKey);
      }
    });
  }

  void _resetPagingController() {
    setState(() {
      _pagingController.dispose();
      _initializePagingController();
    });
  }

  Future<void> _getAppliedJobs({required String token, required int no}) async {
    await _appliedJobCubit.getAppliedJobs(token: token, no: no);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          TextConstants.appliedJob,
          style: WidgetConstants.mainBold16Style,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CandidateCubit, CandidateState>(
        builder: (context, state) {
          if (state is AuthNoLoggedInState) {
            return const Center(
              child: Text(TextConstants.noData,
                  style: WidgetConstants.black16Style),
            );
          }
          return _buildAppliedJob();
        },
      ),
    );
  }

  Widget _buildAppliedJob() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: ValueConstants.deviceWidthValue(uiValue: 25),
          vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: MultiBlocListener(listeners: [
              BlocListener<CandidateCubit, CandidateState>(
                  listener: (context, state) {
                if (state is AuthNoLoggedInState) {
                  _resetPagingController();
                } else if (state is AuthLoginSuccessState) {
                  _resetPagingController();
                  _getAppliedJobs(token: state.token, no: 0);
                }
              }),
              BlocListener<AppliedJobCubit, AppliedJobState>(
                listener: (context, state) {
                  if (state is AppliedJobLoadedState) {
                    if (state.isLastPage) {
                      _pagingController.appendLastPage(state.appliedJobs);
                    } else {
                      _pagingController.appendPage(
                          state.appliedJobs, state.page + 1);
                    }
                  } else if (state is AppliedJobErrorState) {
                    _pagingController.error = state.errMessage;
                  } else if (state is AppliedJobEmptyState ||
                      state is AppliedJobSuccessState) {
                    _resetPagingController();
                  }
                },
              ),
            ], child: _buildJobList()),
          ),
        ],
      ),
    );
  }

  Widget _buildJobList() {
    return PagedListView<int, Job>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Job>(
            itemBuilder: (context, job, index) => JobItem(
                job: job, onIconBookmarkClicked: () async {}, isApplied: true),
            newPageProgressIndicatorBuilder: (_) => const Center(
                  child: WidgetConstants.circularProgress,
                ),
            noItemsFoundIndicatorBuilder: (context) => const Center(
                  child: Text(TextConstants.noData,
                      style: WidgetConstants.black16Style),
                ),
            firstPageErrorIndicatorBuilder: (context) => const Center(
                  child: Text(TextConstants.getAppliedJobError,
                      style: WidgetConstants.black16Style),
                )));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
