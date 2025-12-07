import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsit_mobile/features/applied_jobs/presentation/cubit/applied_job_cubit.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_cubit.dart';
import 'package:jobsit_mobile/core/constants/color_constants.dart';
import 'package:jobsit_mobile/core/constants/text_constants.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';
import 'package:jobsit_mobile/core/constants/widget_constants.dart';
import 'package:jobsit_mobile/features/auth/presentation/cubit/candidate_state.dart';
import 'package:path/path.dart' as path;

import '../../features/jobs/presentation/screens/cv_viewer_screen.dart';

class ApplyBottomSheet extends StatefulWidget {
  const ApplyBottomSheet({super.key, required this.jobId});

  final int jobId;

  @override
  State<ApplyBottomSheet> createState() => _ApplyBottomSheetState();
}

class _ApplyBottomSheetState extends State<ApplyBottomSheet> {
  File? _selectedCV;
  final TextEditingController _controller = TextEditingController();
  late final int _jobId;
  String? _validateMessage;

  @override
  void initState() {
    super.initState();
    _jobId = widget.jobId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(TextConstants.attachedCV,
              style: WidgetConstants.mainBold16Style),
          SizedBox(
            height: ValueConstants.deviceHeightValue(uiValue: 20),
          ),
          GestureDetector(
            onTap: () async => await _selectCV(),
            onLongPress: () {
              if (_selectedCV != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CVViewerScreen(path: _selectedCV!.path),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorConstants.main),
                  borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: _selectedCV != null
                  ? Text(
                      path.basename(_selectedCV!.path),
                      style: WidgetConstants.blackBold16Style,
                    )
                  : const Text(
                      TextConstants.addNewCV,
                      style: WidgetConstants.blackBold16Style,
                    ),
            ),
          ),
          if (_validateMessage != null) ..._buildErrMessage(),
          SizedBox(
            height: ValueConstants.deviceHeightValue(uiValue: 20),
          ),
          const Text(TextConstants.coverLetter,
              style: WidgetConstants.mainBold16Style),
          SizedBox(
            height: ValueConstants.deviceHeightValue(uiValue: 20),
          ),
          TextField(
              controller: _controller,
              minLines: 5,
              maxLines: 5,
              decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: WidgetConstants.inputFieldBorder,
                  focusedBorder: WidgetConstants.inputFieldBorder,
                  hintText: TextConstants.coverLetterHint,
                  hintStyle: WidgetConstants.grey12Style)),
          SizedBox(
            height: ValueConstants.deviceHeightValue(uiValue: 20),
          ),
          GestureDetector(
            onTap: () async => await handleApplyJob(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                  color: ColorConstants.main,
                  borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: const Text(
                TextConstants.submit,
                style: WidgetConstants.whiteBold16Style,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildErrMessage() {
    return [
      SizedBox(
        height: ValueConstants.deviceHeightValue(uiValue: 20),
      ),
      Text(_validateMessage!, style: WidgetConstants.inputFieldErrStyle),
    ];
  }

  Future<void> _selectCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _selectedCV = file;
      });
    }
  }

  Future<void> handleApplyJob() async {
    if (isValidate()) {
      await context.read<AppliedJobCubit>().applyJob(
          token:
              (context.read<CandidateCubit>().state as AuthLoginSuccessState).token,
          cvFile: _selectedCV!,
          letter: _controller.text,
          idJob: _jobId);
      if (mounted) Navigator.pop(context);
    }
  }

  bool isValidate() {
    if (_selectedCV == null) {
      setState(() {
        _validateMessage = TextConstants.pleaseUploadCV;
      });
      return false;
    }

    if (_selectedCV!.path.endsWith('.pdf') &&
        _selectedCV!.lengthSync() / 1024 <= 512) {
      setState(() {
        _validateMessage = null;
      });
      return true;
    }

    setState(() {
      _validateMessage = TextConstants.onlySupportCVFile;
    });
    return false;
  }
}
