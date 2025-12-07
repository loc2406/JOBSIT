import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/features/saved_jobs/presentation/cubit/saved_job_cubit.dart';
import 'package:jobsit_mobile/features/jobs/presentation/screens/job_detail_screen.dart';
import 'package:jobsit_mobile/core/services/job_services.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/features/saved_jobs/presentation/cubit/saved_job_state.dart';

import '../../data/models/job.dart';
import '../../core/constants/value_constants.dart';

class JobItem extends StatefulWidget {
  const JobItem(
      {super.key,
      required this.job,
      this.onIconBookmarkClicked,
      this.isApplied = false});

  final Job job;
  final Future<void> Function()? onIconBookmarkClicked;
  final bool isApplied;

  @override
  State<StatefulWidget> createState() => JobItemState();
}

class JobItemState extends State<JobItem> {
  late final Job job;
  late final Future<void> Function()? onIconBookmarkClicked;
  late final bool isApplied;
  late final SavedJobCubit _savedJobCubit;
  late int differenceInDays;

  @override
  void initState() {
    super.initState();
    job = widget.job;
    onIconBookmarkClicked = widget.onIconBookmarkClicked;
    isApplied = widget.isApplied;
    _savedJobCubit = context.read<SavedJobCubit>();

    final endDate = DateTime.parse(job.endDate).toLocal();
    differenceInDays = (endDate.isBefore(DateTime.now())
        ? 0
        : endDate.difference(DateTime.now().toLocal()).inDays);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: ColorConstants.main, width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: job.companyLogo != null
                      ? Image.network(
                          '${JobServices.displayJobLogoUrl}${job.companyLogo}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildJobDefaultLogo(),
                        )
                      : _buildJobDefaultLogo(),
                ),
                SizedBox(
                  width: ValueConstants.deviceWidthValue(uiValue: 13),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.jobName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: ColorConstants.main,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                      Text(
                        job.companyName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (!isApplied) ...[
                  SizedBox(
                    width: ValueConstants.deviceWidthValue(uiValue: 13),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await onIconBookmarkClicked?.call();
                    },
                    child: BlocBuilder<SavedJobCubit, SavedJobState>(
                      builder: (context, state) {
                        final isSaved = _savedJobCubit
                            .allSavedJobs()
                            .any((job) => job.jobId == this.job.jobId);

                        return Icon(
                                isSaved
                                    ? CupertinoIcons.bookmark_fill
                                    : CupertinoIcons.bookmark,
                                color: ColorConstants.main,
                              );
                      },
                    ),
                  )
                ]
              ],
            ),
            if (!isApplied) ...[
              SizedBox(
                height: ValueConstants.deviceWidthValue(uiValue: 15),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: buildJobPositionsList(),
                ),
              ),
            ],
            SizedBox(
              height: ValueConstants.deviceWidthValue(uiValue: 15),
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: ColorConstants.main,
                ),
                Expanded(
                    child: Text(job.location,
                        maxLines: 1, overflow: TextOverflow.ellipsis))
              ],
            ),
            SizedBox(
              height: ValueConstants.deviceWidthValue(uiValue: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !isApplied
                    ? Row(
                        children: [
                          const Icon(
                            Icons.people,
                            color: ColorConstants.main,
                          ),
                          SizedBox(
                            width: ValueConstants.deviceWidthValue(uiValue: 5),
                          ),
                          Text(
                            job.amount.toString(),
                          )
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: ColorConstants.main,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: const Text(
                          TextConstants.applied,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.clock,
                      color: ColorConstants.main,
                    ),
                    SizedBox(
                      width: ValueConstants.deviceWidthValue(uiValue: 5),
                    ),
                    Text('${differenceInDays}d left')
                  ],
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const JobDetailScreen(),
                settings: RouteSettings(arguments: job)));
      },
    );
  }

  Widget _buildJobDefaultLogo() {
    return const Icon(
      Icons.image_outlined,
      size: 24,
      color: ColorConstants.main,
    );
  }

  List<Container> buildJobPositionsList() {
    return job.positions
        .map((position) => Container(
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: ColorConstants.grayBackground,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Text(
                position.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
              ),
            ))
        .toList();
  }
}
